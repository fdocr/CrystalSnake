require "json"

# A BattleSnake::Context is the representation of the game as it arrives from
# the [Webhook API](https://docs.battlesnake.com/api) request to `src/app.cr`
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

  def dup
    new_context = Context.from_json(to_json)
    new_context.turn = turn + 1
    new_context
  end

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

  # Simulate a move of a snake in some direction
  def move(snake_id, direction)
    index = board.snakes.index! { |snake| snake.id == snake_id }

    # delete last body point
    deleted_point = board.snakes[index].body.pop

    # Move head
    board.snakes[index].head = board.snakes[index].head.move(direction)
    board.snakes[index].body.unshift(board.snakes[index].head)

    # Update You if necessary
    @you = board.snakes[index] if @you.id == snake_id

    # Update the board's snake_points
    board.snake_points.clear
    board.find_snake_points
  end

  # Checks collisions from snakes on the board and removes snakes that die
  def check_collisions
    collisions = [] of String

    # Find collisions
    board.snakes.each_with_index do |snake, i|
      # Boundary collision
      if snake.head.x < 0 || snake.head.y < 0 || snake.head.x > board.width || snake.head.y > board.height
        collisions << snake.id
        next # Don't run any more checks
      end

      # Self-snake-collision
      if snake.body.count { |point| point == snake.head } > 1
        collisions << snake.id 
        next # Don't run any more checks
      end

      board.snakes.each_with_index do |opponent, k|
        # Don't check self
        next if opponent.id == snake.id

        # Head on head collision
        if snake.head == opponent.head
          case snake.body.count { true } <=> opponent.body.count { true }
          when .negative?
            # snake eliminated
            collisions << snake.id
          when .positive?
            # opponent eliminated
            collisions << opponent.id
          else
            # Both eliminated
            collisions << snake.id
            collisions << opponent.id
          end
        end

        # Ran into another snake
        collisions << snake.id if opponent.body.includes?(snake.head)
      end
    end

    # Resolve collisions
    collisions.uniq.each do |id|
      snake = board.snakes.find { |snake| snake.id == id }
      board.snakes.delete(snake)
    end
  end
end