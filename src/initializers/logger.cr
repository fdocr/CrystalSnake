log_level = Kemal.config.env == "development" ? Log::Severity::Info : Log::Severity::Error

Log.setup do |c|
  backend = Log::IOBackend.new

  c.bind("*", log_level, backend)
  c.bind("mosquito.*", log_level, backend)
  c.bind("db", log_level, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter))
end