# Sync (Remote Replication)

Turso supports bidirectional sync between a local embedded database and a remote Turso Cloud instance. This enables offline-first applications where reads are always fast (local) and writes sync when connectivity is available.

## CRITICAL: Always Use the Sync SDK

**A synced database file MUST only be opened through the sync SDK** (e.g., `turso::sync::Builder` in Rust, `turso.sync.connect()` in Python, `tursogo.NewTursoSyncDb()` in Go, etc.).

**NEVER open a synced database with:**
- The `tursodb` CLI
- A non-sync SDK (e.g., plain `turso::Builder` / `turso.connect()`)
- SQLite directly (`sqlite3`, `better-sqlite3`, etc.)
- Any other tool that can open SQLite/WAL files

**Why:** The sync engine relies on specific WAL invariants (frame positions, revision tracking, CDC state) to function correctly. Any external access can trigger a checkpoint or modify the WAL in ways that break these invariants, **corrupting the sync state permanently**. The database may appear fine locally but will fail to push/pull, or worse, silently lose data on the next sync.

If you need to inspect a synced database, make a copy of the file first and open the copy.

## How It Works

Turso sync operates on two layers:

### Physical Layer: WAL Frame Streaming

The local database uses WAL (Write-Ahead Logging) mode. Sync transfers WAL **frames** (page-sized chunks) between local and remote:

- **Pull**: Downloads new frames from remote, applies them to the local WAL
- **Push**: Uploads local WAL frames to remote

Each frame is a 24-byte header + 4096-byte page. Frames are transferred via protobuf over HTTP. Zstd compression is supported.

### Logical Layer: Change Data Capture

For push operations, Turso uses an internal CDC table to track logical changes (INSERT/UPDATE/DELETE). These changes are replayed as SQL on the remote, ensuring correct application-level semantics.

## Core Operations

Every SDK exposes the same four sync operations:

### `pull()`

Downloads remote changes to the local replica.

1. Sends current local revision to remote
2. Remote responds with all frames since that revision
3. Frames are applied to local WAL
4. Local metadata updated with new revision

After pull, local queries immediately see remote changes.

### `push()`

Uploads local changes to the remote.

1. Collects logical changes from local CDC table (since last push)
2. Sends changes as batched SQL to remote
3. Remote applies changes atomically
4. Local metadata updated

### `sync()`

Convenience method: push then pull in sequence. Available in some SDKs (React Native, WASM).

### `checkpoint()`

Compacts the local WAL by writing WAL contents back to the main database file. Reduces local disk usage. The remote may request a checkpoint before accepting a push if the local WAL is too large (~1000 pages threshold).

## Conflict Resolution

Turso uses **last-writer-wins** at both the physical and logical level:

- **Physical conflicts**: Detected when multiple clients push overlapping WAL frame ranges. The push fails with a conflict error — the client must pull first, then retry.
- **Logical conflicts**: No automatic merging. The last push to the remote wins. Changes are ordered by change ID within each generation.

### Typical Conflict Flow

```
Client A: push() → success
Client B: push() → conflict error
Client B: pull() → gets Client A's changes
Client B: push() → success (local changes applied on top)
```

Applications should handle `SQLITE_BUSY` or conflict errors by pulling and retrying.

## Bootstrap

On first sync with an empty local database, a **bootstrap** downloads the full remote database:

- **Full bootstrap** (default): Downloads all pages — the local replica becomes a complete copy
- **Partial bootstrap** (experimental): Downloads only a subset of data, reducing initial bandwidth. Remaining pages are fetched on demand.

### Partial Sync Configuration

Partial sync is experimental and available in JavaScript, WASM, React Native, Python, and Go SDKs. Configuration options:

| Parameter | Description |
|-----------|-------------|
| `bootstrapStrategy` | How to select initial data: `prefix` (load first N bytes) or `query` (load pages touched by a SQL statement) |
| `segmentSize` | Load pages in batches of this many bytes. E.g., with `segmentSize=131072` (128KB), accessing page 1 loads pages 1–32 together |
| `prefetch` | When `true`, the sync engine proactively fetches pages that are likely to be accessed soon based on access patterns |

## Stats

All SDKs expose sync statistics:

| Stat | Description |
|------|-------------|
| `network_received_bytes` | Total bytes downloaded from remote |
| `network_sent_bytes` | Total bytes uploaded to remote |
| `main_wal_size` | Current local WAL size |

## Metadata Persistence

Sync state is stored in a `{db_path}-info` JSON file alongside the database, containing:

- Client unique ID
- Current synced revision (opaque token)
- Last pull/push timestamps
- Last pushed change ID
- Saved remote URL configuration

This file enables resuming sync after application restarts without re-bootstrapping.

## SDK Availability

| SDK | Sync Support | Sync Package/Feature |
|-----|-------------|---------------------|
| Rust | Yes | `turso` crate with `sync` feature |
| Python | Yes | `turso.sync` / `turso.aio.sync` modules |
| Go | Yes | `tursogo.NewTursoSyncDb()` |
| WASM | Yes | `@tursodatabase/sync-wasm` (separate package) |
| React Native | Yes | Built into `@tursodatabase/sync-react-native` |
| JavaScript (Node.js) | Yes | `@tursodatabase/sync` (separate package) |
| Java | No | Not yet available |

## Important Notes

- **NEVER open a synced database outside the sync SDK** — CLI, SQLite, or non-sync SDKs will corrupt sync state
- Sync is **explicit** — call push/pull manually; there is no automatic background sync
- Local reads never block on network — they always read from the local replica
- Push can fail with "checkpoint needed" — call `checkpoint()` then retry
- Pull is idempotent — safe to call multiple times
- Both push and pull are atomic — partial failures don't corrupt the database
- Remote encryption is supported via cipher + key configuration (see SDK-specific docs)
