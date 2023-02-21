require "sam"
require "sentry"
require "../config/config.cr"
require "../db/migrations/*"

load_dependencies "jennifer"

task "dev" do
  sentry = Sentry::ProcessRunner.new(
    display_name: "App",
    build_command: "crystal build ./src/app.cr",
    run_command: "./app",
    run_args: ["-p", "8080"],
    files: [ "./src/**/*" ]
  )

  sentry.run
end

task "test" do
  system "KEMAL_ENV=test crystal spec"
end

Sam.help