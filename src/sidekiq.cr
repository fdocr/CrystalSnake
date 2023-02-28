require "kemal"
require "sidekiq/cli"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
Dotenv.load if File.exists?(".env")

Sidekiq::Client.default_context = Sidekiq::Client::Context.new
# Sidekiq::Client.default_context.logger.setup(:error)

require "./initializers/**"
require "./models/**"
require "./workers/**"

cli = Sidekiq::CLI.new
server = cli.configure do |config|
  # middleware would be added here
  p "CONFIG: #{config.inspect}"
end

# log_level = Kemal.config.env == "development" ? Log::Severity::Error : Log::Severity::Error
# p "WAT (#{Kemal.config.env}): #{log_level}"
# Log.setup "Sidekiq", :error

cli.run(server)