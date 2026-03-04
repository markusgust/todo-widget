require "dotenv/load"
require "pg"

db = PG.connect(ENV.fetch("DATABASE_URL"))
db.exec(File.read(File.join(__dir__, "schema.sql")))
db.exec("ALTER TABLE todos ADD COLUMN IF NOT EXISTS position INTEGER NOT NULL DEFAULT 0")
db.exec(<<~SQL)
  UPDATE todos SET position = sub.rn
  FROM (
    SELECT id, ROW_NUMBER() OVER (ORDER BY created_at ASC) - 1 AS rn FROM todos
  ) sub
  WHERE todos.id = sub.id AND todos.position = 0
SQL
puts "Done."
