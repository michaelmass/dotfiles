import { readAll } from "jsr:@std/io"
import { Database } from "jsr:@db/sqlite";

async function runHook() {
  const stdin = new TextDecoder().decode(await readAll(Deno.stdin))
  const data = JSON.parse(stdin)

  const hookEventName = data.hook_event_name
  const sessionId = data.session_id
  const cwd = data.cwd

  const db = new Database(".claude.db")

  db.exec(`CREATE TABLE IF NOT EXISTS sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hook_event_name TEXT,
    session_id TEXT,
    cwd TEXT,
    data JSON
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`)

  const query = db.prepare(`
    INSERT INTO sessions (hook_event_name, session_id, cwd, data)
    VALUES (?, ?, ?, ?)
  `)

  query.run(hookEventName, sessionId, cwd, data)

  db.close()
}

await runHook().catch((e) => {
  Deno.writeFileSync(".claude.error", new TextEncoder().encode(e))
})
