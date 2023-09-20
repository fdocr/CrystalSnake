require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
Dotenv.load if File.exists?(".env")
require "../config/**"
require "./models/**"
require "./jobs/**"

Mosquito::Runner.start