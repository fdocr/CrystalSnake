require "kemal"
require "dotenv"

Dotenv.load if Kemal.config.env == "development"

require "./initializers/**"

require "../src/l_tree"
require "../src/battle_snake/**"
require "../src/strategy/**"

# require "../src/models/application_record.cr"
require "../src/models/*"

