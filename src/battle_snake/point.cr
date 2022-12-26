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

  def initialize(str : String)
    @x, @y = str.split(",").map(&.to_i)
  end

  def <=>(other : Point)
    (x - other.x).abs + (y - other.y).abs
  end

  def to_s
    "#{x},#{y}"
  end

  def move?(target : Point)
    case target
    when up
      "up"
    when left
      "left"
    when down
      "down"
    when right
      "right"
    else
      ""
    end
  end

  def up
    Point.new(x, y + 1)
  end

  def left
    Point.new(x - 1, y)
  end

  def down
    Point.new(x, y - 1)
  end

  def right
    Point.new(x + 1, y)
  end
end