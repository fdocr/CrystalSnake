require "dotenv"
Dotenv.load

require "../config/database"
require "sam"
require "sentry"
require "../db/migrations/*"

load_dependencies "jennifer"

task "dev" do
  build_step = "
    crystal build ./src/app.cr &&
    crystal build ./src/worker.cr &&
    crystal build ./src/bundle.cr
  "
  sentry = Sentry::ProcessRunner.new(
    display_name: "App",
    build_command: build_step,
    run_command: "./bundle",
    files: [ "./src/**/*", "./config/*.cr" ]
  )
  sentry.run
end

task "test" do
  res = system "KEMAL_ENV=test crystal spec"
  raise "Tests failed!" unless res
end

Sam.help