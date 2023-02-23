require "kemal"
require "dotenv"

Dotenv.load if Kemal.config.env == "development"

require "./initializers/**"
# Import record (model) so jennifer.cr has access to it
require "../src/battle_snake/record.cr"
