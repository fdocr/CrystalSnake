require "json"

class BattleSnake::Settings
  include JSON::Serializable

  @[JSON::Field(key: "foodSpawnChance")]
  property foodSpawnChance : Int32

  @[JSON::Field(key: "minimumFood")]
  property minimumFood : Int32

  @[JSON::Field(key: "hazardDamagePerTurn")]
  property hazardDamagePerTurn : Int32

  @[JSON::Field(key: "hazardMap")]
  property hazardMap : String

  @[JSON::Field(key: "hazardMapAuthor")]
  property hazardMapAuthor : String

  # TODO: royale & squad data as objects
end