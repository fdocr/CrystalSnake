require "sam"
require "sentry"

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

task "micrate" do
  system "cp .micrate bin/micrate" unless File.exists?("bin/micrate")
  system "chmod +x bin/micrate"
end

Sam.help