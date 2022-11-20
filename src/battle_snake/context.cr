require "json"

class BattleSnake::Context
  include JSON::Serializable

  @[JSON::Field(key: "game")]
  property game : Game

  @[JSON::Field(key: "turn")]
  property turn : Int32

  @[JSON::Field(key: "board")]
  property board : Board

  @[JSON::Field(key: "you")]
  property you : Snake

  @valid_moves = [] of String
  @valid_moves_loaded = false

  def valid_moves
    return @valid_moves if @valid_moves_loaded

    if you.head.y < (board.height - 1)
      target_point = Point.new(you.head.x, you.head.y + 1)
      @valid_moves << "up" unless board.snake_points.includes?(target_point)
    end

    if you.head.x > 0
      target_point = Point.new(you.head.x - 1, you.head.y)
      @valid_moves << "left" unless board.snake_points.includes?(target_point)
    end

    if you.head.y > 0
      target_point = Point.new(you.head.x, you.head.y - 1)
      @valid_moves << "down" unless board.snake_points.includes?(target_point)
    end

    if you.head.x < (board.width - 1)
      target_point = Point.new(you.head.x + 1, you.head.y)
      @valid_moves << "right" unless board.snake_points.includes?(target_point)
    end

    @valid_moves_loaded = true
    @valid_moves
  end
end