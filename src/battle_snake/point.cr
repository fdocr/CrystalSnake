require "json"

class BattleSnake::Point
  include Comparable(Point)
  include JSON::Serializable

  @[JSON::Field(key: "x")]
  property x : Int32

  @[JSON::Field(key: "y")]
  property y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def <=>(other : Point)
    (x - other.x).abs + (y - other.y).abs
  end
end