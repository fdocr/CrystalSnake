require "json"

class BattleSnake::Point
  include JSON::Serializable

  @[JSON::Field(key: "x")]
  property x : Int32

  @[JSON::Field(key: "y")]
  property y : Int32
end