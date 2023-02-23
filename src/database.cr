require "granite"
require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "db", url: ENV["DATABASE_URL"])
