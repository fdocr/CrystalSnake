require "json"

class BattleSnake::Board
  include JSON::Serializable

  @[JSON::Field(key: "height")]
  property height : Int32

  @[JSON::Field(key: "width")]
  property width : Int32

  @[JSON::Field(key: "snakes")]
  property snakes : Array(Snake)

  @[JSON::Field(key: "food")]
  property food : Array(Point)

  @[JSON::Field(key: "hazards")]
  property hazards : Array(Point)
end