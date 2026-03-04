require "pg"

DB = PG.connect(ENV.fetch("DATABASE_URL"))
