require "kemal"
require "jennifer"
require "sidekiq"

log_level = Kemal.config.env == "development" ? Log::Severity::Error : Log::Severity::Error
p "LOG LEVEL: #{log_level}"

Log.setup do |c|
  backend = Log::IOBackend.new
  jennifer_backend = Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter)

  c.bind "*", log_level, backend
  c.bind "db.*", log_level, jennifer_backend
  c.bind "Sidekiq", log_level, backend
end