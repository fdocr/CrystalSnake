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

  def enemies
    board.snakes.reject { |snake| snake.id == you.id }
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
  # 
  # TODO: Take into account the last point of snakes that will move on next
  # turn, which would be in fact valid moves (not counted at the moment).
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

  # Similar to `BattleSnake::Context#valid_moves` but considers all valid
  # moves from enemies. Returns a hash with all the valid `:moves`,
  # `:neighbors` and `:risky_moves` (we might collide with enemy) available
  # for `you`.
  #
  # `:moves` is an `Array(BattleSnake::Point)` that containts the directions
  # from the given `#point` that are valid to move without dying
  # (`"up"/"left"/"down"/"right"`).
  #
  # `:risky_moves` is an `Array(BattleSnake::Point)` that containts the
  # directions from the given `#point` that are valid to move but there's a
  # chance we could die (`"up"/"left"/"down"/"right"`).
  #
  # `:neighbors` is a `{} of String => BattleSnake::Point` that contains those
  # directions' coordinates.
  def blast_valid_moves!
    moves = [] of String
    risky_moves = [] of String

    # Remove last body point from `you`, taking into account both
    # `context.you` and `board.snakes` before starting work
    you.body.pop
    index = board.snakes.index! { |snake| snake.id == you.id }
    board.snakes[index].body.pop
    possible_moves = valid_moves(you.head)

    # Get `valid_moves` for each enemy on the board
    enemy_valid_moves = {} of String => Array(String)
    enemies.each_with_index do |snake, index|
      snake_moves = valid_moves(snake.head)[:moves]
      enemy_valid_moves[snake.id] = snake_moves unless snake_moves.empty?
    end

    # Without enemy valid moves we can fallback to our possible_moves as valid
    return {
      moves: possible_moves[:moves],
      neighbors: possible_moves[:neighbors],
      risky_moves: risky_moves
    } if enemy_valid_moves.empty?

    # Build contexts for all possible enemy `valid_moves` permutations
    contexts = [] of BattleSnake::Context
    permutations = enemy_valid_moves.values
                                    .map(&.size)
                                    .reduce { |acc, i| acc * i }
    permutations.times { contexts << self.dup }
    contexts.each_with_index do |context, index|
      # Perform each enemy corresponding move per permutation
      offset = 1
      enemy_valid_moves.each do |snake_id, moves|
        direction = moves[(index / offset).floor.to_i % moves.size]
        context.move(snake_id, direction)
        offset = offset * moves.size
      end
    end

    possible_moves[:moves].each do |direction|
      target = possible_moves[:neighbors][direction]
      collision = contexts.find do |context|
        context.board.snake_points.includes?(target)
      end

      if collision.nil?
        moves << direction
      else
        risky_moves << direction
      end
    end

    {
      moves: moves,
      neighbors: possible_moves[:neighbors],
      risky_moves: risky_moves
    }
  end


  # Simulate a move of a snake in some direction
  # Remove last body point from you taking into account both
  # context.you and board.snakes
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
          case snake.body.size <=> opponent.body.size
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