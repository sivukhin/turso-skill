---
name: turso-db
description: >
  Turso (Limbo) database helper — an in-process SQLite-compatible database written in Rust.
  Formerly known as libSQL / libsql. Replaces @libsql/client, libsql-experimental for Turso use cases.
  Features: vector search, full-text search, CDC, MVCC, encryption, remote sync.
  SDKs: JavaScript (@tursodatabase/database), WASM (@tursodatabase/database-wasm),
  React Native (@tursodatabase/sync-react-native), Rust (turso), Python (pyturso), Go (tursogo).
---

# Turso Database

Turso is an in-process SQL database compatible with SQLite, written in Rust.

## Critical Rules

Before writing any Turso code, you MUST know these constraints:

- **BETA software** — not all SQLite features are implemented yet
- **No multi-process access** — only one process can open a database file at a time
- **No WITHOUT ROWID tables** — all tables must have a rowid
- **No vacuum** — VACUUM is not supported
- **UTF-8 only** — the only supported character encoding
- **WAL is the default journal mode** — legacy SQLite modes (delete, truncate, persist) are not supported
- **FTS requires compile-time `fts` feature** — not available in all builds
- **Encryption requires `--experimental-encryption` flag** — not enabled by default
- **MVCC is experimental and not production ready** — `PRAGMA journal_mode = experimental_mvcc`
- **Vector distance: lower = closer** — ORDER BY distance ASC for nearest neighbors

## Feature Decision Tree

Use this to decide which reference file to load:

**Need vector similarity search?** (embeddings, nearest neighbors, cosine distance)
→ Read `references/vector-search.md`

**Need full-text search?** (keyword search, BM25 ranking, tokenizers, fts_match/fts_score)
→ Read `references/full-text-search.md`

**Need to track database changes?** (audit log, change feed, replication)
→ Read `references/cdc.md`

**Need concurrent write transactions?** (multiple writers, snapshot isolation, BEGIN CONCURRENT)
→ Read `references/mvcc.md`

**Need database encryption?** (encryption at rest, AES-GCM, AEGIS ciphers)
→ Read `references/encryption.md`

**Need remote sync / replication?** (push/pull, offline-first, Turso Cloud, embedded replicas)
→ Read `references/sync.md`

## SDK Decision Tree

**JavaScript / TypeScript / Node.js?**
→ Read `sdks/javascript.md`

**Browser / WebAssembly / WASM?**
→ Read `sdks/wasm.md`

**React Native / Mobile?**
→ Read `sdks/react-native.md`

**Rust?**
→ Read `sdks/rust.md`

**Python?**
→ Read `sdks/python.md`

**Go?**
→ Read `sdks/go.md`

## SDK Install Quick Reference

| Language | Package | Install Command |
|----------|---------|-----------------|
| JavaScript (Node.js) | `@tursodatabase/database` | `npm i @tursodatabase/database` |
| JavaScript Sync | `@tursodatabase/sync` | `npm i @tursodatabase/sync` |
| WASM (Browser) | `@tursodatabase/database-wasm` | `npm i @tursodatabase/database-wasm` |
| WASM + Sync | `@tursodatabase/sync-wasm` | `npm i @tursodatabase/sync-wasm` |
| React Native | `@tursodatabase/sync-react-native` | `npm i @tursodatabase/sync-react-native` |
| Rust | `turso` | `cargo add turso` |
| Python | `pyturso` | `pip install pyturso` |
| Go | `tursogo` | `go get turso.tech/database/tursogo` |

## CLI Quick Reference

```bash
# Install Turso CLI
curl --proto '=https' --tlsv1.2 -LsSf \
  https://github.com/tursodatabase/turso/releases/latest/download/turso_cli-installer.sh | sh

# Or via Homebrew
brew install turso

# Start interactive SQL shell
tursodb

# Open a database file
tursodb mydata.db

# Read-only mode
tursodb --readonly mydata.db

# Start MCP server
tursodb your.db --mcp
```

## SQL Quick Reference

```sql
-- Create table
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT);

-- Insert
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');

-- Select
SELECT * FROM users WHERE name = 'Alice';

-- Update
UPDATE users SET email = 'new@example.com' WHERE id = 1;

-- Delete
DELETE FROM users WHERE id = 1;

-- Transactions
BEGIN TRANSACTION;
INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');
COMMIT;
```

## MCP Server

Turso can run as an MCP (Model Context Protocol) server:

```bash
tursodb your.db --mcp
```

This starts a server that exposes the database via the MCP protocol, allowing AI tools and agents to query and modify the database directly.

## Complete File Index

| File | Description |
|------|-------------|
| `SKILL.md` | Main entry point — decision trees, critical rules, quick references |
| `references/vector-search.md` | Vector types, distance functions, semantic search examples |
| `references/full-text-search.md` | FTS with Tantivy: tokenizers, query syntax, fts_match/fts_score/fts_highlight |
| `references/cdc.md` | Change Data Capture: modes, CDC table schema, usage examples |
| `references/mvcc.md` | MVCC: BEGIN CONCURRENT, snapshot isolation, conflict handling |
| `references/encryption.md` | Page-level encryption: ciphers, key setup, URI format |
| `references/sync.md` | Remote sync: push/pull, conflict resolution, bootstrap, WAL streaming |
| `sdks/javascript.md` | @tursodatabase/database: connect, prepare, run/get/all/iterate |
| `sdks/wasm.md` | @tursodatabase/database-wasm: browser WASM, OPFS, sync-wasm |
| `sdks/react-native.md` | @tursodatabase/sync-react-native: mobile, sync, encryption |
| `sdks/rust.md` | turso crate: Builder, async execute/query, sync feature |
| `sdks/python.md` | pyturso: DB-API 2.0, turso.aio async, turso.sync remote |
| `sdks/go.md` | tursogo: database/sql driver, no CGO, sync driver |
