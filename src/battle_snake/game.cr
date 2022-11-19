require "json"

class BattleSnake::Game
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  property id : String

  @[JSON::Field(key: "ruleset")]
  property ruleset : Ruleset

  @[JSON::Field(key: "map")]
  property map : String

  @[JSON::Field(key: "timeout")]
  property timeout : Int32

  @[JSON::Field(key: "source")]
  property source : String
end