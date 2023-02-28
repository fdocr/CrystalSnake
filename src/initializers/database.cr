require "kemal"
require "jennifer"
require "jennifer/adapter/postgres"

# Configure log level. INFO by default, then using "LOG_LEVEL" ENV var if
# available. If ENV var isn't available the default for production environments
# changes to ERROR
#
# TODO: This is copy&pasted in src/initializers/logger.cr and that's not good
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

Jennifer::Config.configure do |conf|
  conf.from_uri(ENV["DATABASE_URL"]) if ENV.has_key?("DATABASE_URL")
  conf.logger.level = log_level
  conf.adapter = "postgres"
  conf.pool_size = (ENV["DB_POOL"] ||= "5").to_i
end
