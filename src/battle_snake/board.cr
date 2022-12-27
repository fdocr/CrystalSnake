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

  # `Array(Point)` variable populated when a Board is initialized that contains
  # all hazards that would cause a collision
  @snake_points = [] of Point
  getter snake_points : Array(Point)

  def after_initialize
    snakes.each do |snake|
      snake.body.each do |point|
        @snake_points << point unless @snake_points.includes?(point)
      end
    end
  end
end