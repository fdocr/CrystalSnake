#! /usr/bin/env crystal
#
# To build a standalone command line client, require the
# driver you wish to use and use `Micrate::Cli`.
#

channel = Channel(Nil).new

spawns = ["./app -p 8080", "./worker"].map do |command|
  spawn do
    res = system command
    channel.send(nil) unless res
  end
end

channel.receive