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

  def valid_moves(point : Point)
    moves = [] of String
    neighbors = {} of String => Point

    up = point.up
    if up.y < board.height && !board.snake_points.includes?(up)
      moves << "up"
      neighbors["up"] = up
    end

    left = point.left
    if left.x >= 0 && !board.snake_points.includes?(left)
      moves << "left"
      neighbors["left"] = left
    end

    down = point.down
    if down.y >= 0 && !board.snake_points.includes?(down)
      moves << "down"
      neighbors["down"] = down
    end

    right = point.right
    if right.x < board.width && !board.snake_points.includes?(right)
      moves << "right"
      neighbors["right"] = right
    end

    { moves: moves, neighbors: neighbors }
  end
end