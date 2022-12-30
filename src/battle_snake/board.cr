require "json"

# Represents the Board as it arrives from the BattleSnake API endpoint.
#
# *@snake_points* is an `Array(BattleSnake::Point)` variable populated when a
# Board is initialized and contains all the Points that are currently occupied
# by a snake (would represent a collision).
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

  @snake_points = [] of Point
  getter snake_points : Array(Point)

  def find_snake_points
    snakes.each do |snake|
      snake.body.each do |point|
        @snake_points << point unless @snake_points.includes?(point)
      end
    end
  end

  def after_initialize
    find_snake_points
  end
end