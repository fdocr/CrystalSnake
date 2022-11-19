require "json"

class BattleSnake::Snake
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  property id : String

  @[JSON::Field(key: "name")]
  property name : String

  @[JSON::Field(key: "latency")]
  property latency : String

  @[JSON::Field(key: "health")]
  property health : Int32

  @[JSON::Field(key: "body")]
  property body : Array(Point)

  @[JSON::Field(key: "head")]
  property head : Point

  @[JSON::Field(key: "length")]
  property length : Int32

  @[JSON::Field(key: "shout")]
  property shout : String

  @[JSON::Field(key: "squad")]
  property squad : String

  # TODO: customizations (optional)
  # @[JSON::Field(key: "customizations")]
  # property customizations : String
end