require "dotenv"
Dotenv.load

require "../config/database"
require "sam"
require "sentry"
require "../db/migrations/*"

load_dependencies "jennifer"

task "dev" do
  sentry = Sentry::ProcessRunner.new(
    display_name: "App",
    build_command: "crystal build ./src/app.cr",
    run_command: "./app",
    run_args: ["-p", "8080"],
    files: [ "./src/**/*", "./config/*.cr" ]
  )
  sentry.run
end

task "test" do
  res = system "KEMAL_ENV=test crystal spec"
  raise "Tests failed!" unless res
end

Sam.help