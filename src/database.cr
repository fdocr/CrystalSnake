require "micrate"
require "granite"
require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "db", url: ENV["DATABASE_URL"])

Micrate::DB.connect do |db|
  res = Micrate.migration_status(db)
  if res.values.includes?(nil)
    p "Running pending migrations..."
    Micrate.up(db)
    p "Migrations are now up to date"
  end
end