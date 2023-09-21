require "dotenv"
Dotenv.load

require "../config/database"
require "sam"
require "sentry"
require "../db/migrations/*"

load_dependencies "jennifer"

task "dev" do
  sentry = [
    Sentry::ProcessRunner.new(
      display_name: "App",
      build_command: "crystal build ./src/app.cr",
      run_command: "./app",
      run_args: ["-p", "8080"],
      files: [ "./src/**/*" ]
    ),
    Sentry::ProcessRunner.new(
      display_name: "Worker",
      build_command: "crystal build ./src/worker.cr",
      run_command: "./worker",
      files: [ "./src/**/*" ]
    )
  ]

  # Execute runners in separate threads
  sentry.each { |s| spawn { s.run } }

  begin
    sleep
  rescue
    sentry.each(&.kill)
  end
end

task "test" do
  res = system "KEMAL_ENV=test crystal spec"
  raise "Tests failed!" unless res
end

Sam.help