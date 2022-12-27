require "json"

# A BattleSnake::Context is the representation of the game as it arrives from
# the [Webhook API](https://docs.battlesnake.com/api) request to `app.cr`
# endpoints.
#
# The context's key method is `#valid_moves`
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

  # Returns a hash with all the valid `:moves` and `:neighbors` available from
  # a given `BattleSnake::Point`.
  #
  # `:moves` is an `Array(BattleSnake::Point)` that containts the directions
  # from the given `#point` that are valid to move without dying
  # (`"up"/"left"/"down"/"right"`).
  #
  # `:neighbors` is a `{} of String => BattleSnake::Point` that contains those
  # directions' coordinates.
  #
  # Example:
  #
  # ```
  # context.valid_moves(Point.new(1,1))
  # => {
  #   moves: [ "up", "right" ],
  #   neighbors: { Point.new(2,1), Point.new(1,2) }
  # }
  # ```
  #
  # NOTE: A common method to help manipulate the results is
  # `BattleSnake::Point#move?`. An example of this in practice is the
  # `Strategy::Utils.a_star` method implementation.
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