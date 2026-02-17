# JavaScript SDK

Package: `@tursodatabase/database`

## Installation

```bash
npm i @tursodatabase/database
```

For browser/WASM usage, see `sdks/wasm.md` instead.

## Quick Start

```javascript
import { connect } from '@tursodatabase/database';

const db = await connect('mydata.db');
const row = db.prepare('SELECT 1 AS value').get();
console.log(row); // { value: 1 }
```

## API Reference

### `connect(path)` → Database

Opens a database connection. Creates the file if it doesn't exist.

```javascript
// File-based database
const db = await connect('mydata.db');

// In-memory database
const db = await connect(':memory:');
```

### class Database

#### `db.prepare(sql)` → Statement

Prepare a SQL statement for execution.

```javascript
const stmt = db.prepare('SELECT * FROM users WHERE id = ?');
```

#### `db.exec(sql)`

Execute a SQL statement directly (no results returned).

```javascript
db.exec('CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)');
```

#### `db.close()`

Close the database connection.

### class Statement

#### `stmt.run([...params])` → info

Execute and return info object with `changes` (modified row count) and `lastInsertRowid`.

```javascript
const info = db.prepare('INSERT INTO users (name) VALUES (?)').run('Alice');
console.log(info.changes);        // 1
console.log(info.lastInsertRowid); // 1
```

#### `stmt.get([...params])` → row

Execute and return the first row as an object.

```javascript
const user = db.prepare('SELECT * FROM users WHERE id = ?').get(1);
console.log(user); // { id: 1, name: 'Alice' }
```

#### `stmt.all([...params])` → array of rows

Execute and return all rows as an array.

```javascript
const users = db.prepare('SELECT * FROM users').all();
console.log(users); // [{ id: 1, name: 'Alice' }, ...]
```

#### `stmt.iterate([...params])` → iterator

Execute and return an iterator over rows.

```javascript
for (const row of db.prepare('SELECT * FROM users').iterate()) {
    console.log(row.name);
}
```

## Complete Example

```javascript
import { connect } from '@tursodatabase/database';

const db = await connect('app.db');

db.exec(`
    CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        done INTEGER DEFAULT 0
    )
`);

// Insert
db.prepare('INSERT INTO todos (title) VALUES (?)').run('Buy groceries');
db.prepare('INSERT INTO todos (title) VALUES (?)').run('Write code');

// Query
const pending = db.prepare('SELECT * FROM todos WHERE done = ?').all(0);
console.log(pending);

// Update
db.prepare('UPDATE todos SET done = 1 WHERE id = ?').run(1);

db.close();
```

## Notes

- API is compatible with the libSQL promise API (async variant of `better-sqlite3`)
- Install canary releases with `npm i @tursodatabase/database@next` for preview/experimental features
- `transaction()`, `pragma()`, `backup()`, `serialize()`, `function()`, `aggregate()` are not yet supported
- `pluck()`, `expand()`, `raw()`, `columns()`, `bind()` on Statement are not yet supported
