require "kemal"
require "dotenv"

Dotenv.load unless Kemal.config.env == "production"

require "./initializers/**"
# Import record (model) so jennifer.cr has access to it
require "../src/battle_snake/record.cr"
