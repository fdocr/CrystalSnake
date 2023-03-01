#! /usr/bin/env crystal
#
# Runs both the server and worker executables in separate fibers to avoid
# independent deployments. Motivation is saving costs
#

channel = Channel(Nil).new

spawns = ["./app -p 8080", "./worker"].map do |command|
  spawn do
    res = system command
    channel.send(nil) unless res
  end
end

channel.receive