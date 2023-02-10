require "json"

# Represents a Point (x,y) coordinate on the board with some helper methods for
# processing of the board (i.e. `#move?`)
class BattleSnake::Point
  include Comparable(self)
  include JSON::Serializable

  @[JSON::Field(key: "x")]
  property x : Int32

  @[JSON::Field(key: "y")]
  property y : Int32

  # Initialize from two Int32 values
  def initialize(@x : Int32, @y : Int32)
  end

  # Initialize from a string representation i.e. "x,y"
  def initialize(str : String)
    @x, @y = str.split(",").map(&.to_i)
  end

  def <=>(other : Point)
    (x - other.x).abs + (y - other.y).abs
  end

  # Returns the String representation of the Point. Example:
  #
  # ```
  # Point.new(2,2).to_s
  # => "2,2"
  # ```
  def to_s
    "#{x},#{y}"
  end

  # Determines if a given *target* BattleSnake::Point is reachable. It returns
  # the direction the point itself needs to move to get to the `target`. It
  # returns an empty string if unreachable in one move.
  #
  # NOTE: The result of this method is a mathematic/geometric operation and
  # does not take into account the current board/game, i.e. using negative
  # numbers will return valid results but aren't needed or practical.
  #
  # Example:
  #
  # ```
  # Point.new(1,1).move?(Point.new(1,2))
  # => "right"
  #
  # Point.new(2,1).move?(Point.new(1,1))
  # => "up"
  #
  # # Unreachable in one move
  # Point.new(1,1).move?(Point.new(3,3))
  # => ""
  #
  # # Valid result but not used in real scenarios
  # Point.new(-20,-10).move?(Point.new(-20,-11))
  # => "down"
  # ```
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

  # Returns the point when it moves in a direction. Works the same way as #up,
  # left, etc. but with a string parameter so it's easier to manipulate
  def move(direction)
    case direction
    when "up"
      up
    when "left"
      left
    when "down"
      down
    when "right"
      right
    else
      self
    end
  end

  # Returns a new Point directly up from the instance
  def up
    Point.new(x, y + 1)
  end

  # Returns a new Point directly left from the instance
  def left
    Point.new(x - 1, y)
  end

  # Returns a new Point directly down from the instance
  def down
    Point.new(x, y - 1)
  end

  # Returns a new Point directly right from the instance
  def right
    Point.new(x + 1, y)
  end
end