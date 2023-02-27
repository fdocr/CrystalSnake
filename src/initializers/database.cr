require "kemal"
require "jennifer"
require "jennifer/adapter/postgres"

log_level = Kemal.config.env == "development" ? Log::Severity::Debug : Log::Severity::Error

Jennifer::Config.configure do |conf|
  conf.from_uri(ENV["DATABASE_URI"]) if ENV.has_key?("DATABASE_URI")
  conf.logger.level = log_level
  conf.adapter = "postgres"
  conf.pool_size = (ENV["DB_POOL"] ||= "5").to_i
end

Log.setup "db", log_level, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)
