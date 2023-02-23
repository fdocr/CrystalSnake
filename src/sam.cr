p "1"
require "../config/config.cr"
p "2"
require "sam"
p "3"
require "sentry"
p "4"
require "../db/migrations/*"
p "5"

load_dependencies "jennifer"
p "6"

task "dev" do
  sentry = Sentry::ProcessRunner.new(
    display_name: "App",
    build_command: "crystal build ./src/app.cr --error-trace",
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