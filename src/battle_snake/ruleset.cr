require "json"

class BattleSnake::Ruleset
  include JSON::Serializable

  @[JSON::Field(key: "name")]
  property name : String

  @[JSON::Field(key: "version")]
  property version : String

  @[JSON::Field(key: "settings")]
  property settings : Settings
end