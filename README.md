# turso-db skill

An installable skill that helps AI coding agents work with Turso, an in-process SQLite-compatible database written in Rust.

## What's Included

- **Vector search** -- vector32/64/sparse types, cosine/L2/Jaccard distance functions
- **Full-text search** -- Tantivy-powered FTS with BM25 scoring, tokenizers, highlighting
- **CDC** -- Change Data Capture for audit logs and change feeds
- **MVCC** -- Concurrent transactions with snapshot isolation
- **Encryption** -- Page-level encryption at rest (AES-GCM, AEGIS)
- **Sync** -- Push/pull replication, offline-first, WAL frame streaming
- **SDK references** -- JavaScript, WASM, React Native, Rust, Python, Go

## Install

### Universal (recommended)

Works with Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, Goose, OpenCode, Windsurf, and more:

```bash
npx skills add sivukhin/turso-skill
```

### Shell installer (fallback)

Global install (all projects):

```bash
curl -fsSL https://raw.githubusercontent.com/sivukhin/turso-skill/main/install.sh | bash
```

Local install (current project only):

```bash
curl -fsSL https://raw.githubusercontent.com/sivukhin/turso-skill/main/install.sh | bash -s -- --local
```

The shell installer copies the skill to Claude Code, Cursor, Windsurf, Cline, and OpenCode.

## Usage

Once installed, use `/turso-db` in your AI coding agent to get help with Turso features and APIs.

## Structure

```
turso-skill/
├── skill/
│   └── turso-db/
│       ├── SKILL.md                        # Main entry point (loaded on skill trigger)
│       ├── references/
│       │   ├── vector-search.md            # Vector functions and distance metrics
│       │   ├── full-text-search.md         # FTS with Tantivy
│       │   ├── cdc.md                      # Change Data Capture
│       │   ├── mvcc.md                     # MVCC concurrent transactions
│       │   ├── encryption.md               # Page-level encryption
│       │   └── sync.md                     # Remote sync and replication
│       └── sdks/
│           ├── javascript.md               # @tursodatabase/database
│           ├── wasm.md                     # @tursodatabase/database-wasm
│           ├── react-native.md             # @tursodatabase/sync-react-native
│           ├── rust.md                     # turso crate
│           ├── python.md                   # pyturso
│           └── go.md                       # tursogo
├── install.sh                              # Multi-agent shell installer
└── README.md                               # This file
```

## Credits & Inspiration

- **[opentui-skill](https://github.com/msmps/opentui-skill)** by [msmps](https://github.com/msmps) -- repo structure and multi-agent installer pattern
- **[skills](https://github.com/vercel-labs/skills)** by Vercel Labs -- universal `npx skills add` installer
