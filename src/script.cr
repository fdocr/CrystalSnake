require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
dev_env = Kemal.config.env == "development"
Dotenv.load if File.exists?(".env") && dev_env

require "../config/**"
require "./models/**"
require "./jobs/**"

# Script goes here