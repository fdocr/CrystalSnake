# Use Kemal app handler
class AppLogHandler < Kemal::BaseLogHandler
  def initialize
    @handler = HTTP::LogHandler.new
  end

  def call(context : HTTP::Server::Context)
    @handler.next = @next
    @handler.call(context)
  end

  def write(message : String)
    Log.info { message.strip }
  end
end
Kemal.config.logger = AppLogHandler.new

# Configure log level. INFO by default, then using "LOG_LEVEL" ENV var if
# available. If ENV var isn't available the default for production environments
# changes to ERROR
#
# TODO: This is copy&pasted in src/initializers/database.cr and that's not good
log_level = Log::Severity::Info
if ENV["LOG_LEVEL"]?.presence
  case ENV["LOG_LEVEL"]
  when "TRACE"
    log_level = Log::Severity::Trace
  when "DEBUG"
    log_level = Log::Severity::Debug
  when "INFO"
    log_level = Log::Severity::Info
  when "NOTICE"
    log_level = Log::Severity::Notice
  when "WARN"
    log_level = Log::Severity::Warn
  when "ERROR"
    log_level = Log::Severity::Error
  when "FATAL"
    log_level = Log::Severity::Fatal
  when "NONE"
    log_level = Log::Severity::None
  end
elsif Kemal.config.env == "production"
  log_level = Log::Severity::Error
end

# Configure Log levels
Log.setup do |c|
  backend = Log::IOBackend.new

  c.bind("*", log_level, backend)
  c.bind("mosquito.*", log_level, backend)
  c.bind("db", log_level, Log::IOBackend.new(formatter: Jennifer::Adapter::DBFormatter))
end