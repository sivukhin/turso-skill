# turso-db skill for Claude Code

An installable skill that helps Claude Code work with Turso, an in-process SQLite-compatible database written in Rust.

## What's Included

- **Vector search** — vector32/64/sparse types, cosine/L2/Jaccard distance functions
- **Full-text search** — Tantivy-powered FTS with BM25 scoring, tokenizers, highlighting
- **CDC** — Change Data Capture for audit logs and change feeds
- **MVCC** — Concurrent transactions with snapshot isolation
- **Encryption** — Page-level encryption at rest (AES-GCM, AEGIS)
- **SDK references** — JavaScript, WASM, React Native, Rust, Python, Go

## Install

```bash
# Option 1: Run the installer
bash install.sh

# Option 2: Copy manually
cp -r . ~/.claude/skills/turso-db
```

## Usage

Once installed, use `/turso-db` in Claude Code to get help with Turso features and APIs.

## Structure

```
turso-skill/
├── SKILL.md                        # Main entry point (loaded on skill trigger)
├── references/
│   ├── vector-search.md            # Vector functions and distance metrics
│   ├── full-text-search.md         # FTS with Tantivy
│   ├── cdc.md                      # Change Data Capture
│   ├── mvcc.md                     # MVCC concurrent transactions
│   └── encryption.md               # Page-level encryption
├── sdks/
│   ├── javascript.md               # @tursodatabase/database
│   ├── wasm.md                     # @tursodatabase/database-wasm
│   ├── react-native.md             # @tursodatabase/sync-react-native
│   ├── rust.md                     # turso crate
│   ├── python.md                   # pyturso
│   └── go.md                       # tursogo
├── install.sh                      # Shell installer
└── README.md                       # This file
```
