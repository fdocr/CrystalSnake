# Strategy that chases the closest available food from the board with caution
# against head-to-head collisions. When a potentially dangerous move is in the
# way it analyzes the other valid moves available and picks the one with the 
# most open area of the board to avoid enclosed spaces.
class Strategy::CautiousCarol < Strategy::Base
  def move
    @context.board.snakes.each { |snake| snake.body.pop }
    @context.you.body.pop
    valid_moves = @context.valid_moves(@context.you.head)
    return RandomValid.new(@context).move if valid_moves[:moves].empty?

    # Check for head-to-head collision possibilities
    dangerous_moves = Utils.possible_collisions(@context)

    # Calculate chase closest food direction
    closest_food = ChaseClosestFood.new(@context).move
    target_point = @context.you.head.move(closest_food)
    closest_food_area = 0

    # Use flood fill to check the available space to move for valid_moves and
    # attempt to avoid small areas
    flood_fills = {} of Int32 => String
    contexts = {} of String => BattleSnake::Context
    valid_moves[:moves].each do |move|
      contexts[move] = @context.dup
      contexts[move].move(@context.you.id, move, false)
      area_size = Utils.flood_fill(contexts[move].you.head, contexts[move]).size
      flood_fills[area_size] = move
      closest_food_area = area_size if move == closest_food
    end

    # Safe move if not considered dangerous (collision) or too small space
    safe_move = dangerous_moves.find { |p| (p <=> target_point).zero? }.nil?
    safe_area = closest_food_area >= @context.you.body.size
    return closest_food if safe_move && safe_area

    # Leftover valid moves (not chasing closest food anymore) & fallback to
    # RandomValid if no other moves are available (likely run into own death)
    return flood_fills[flood_fills.keys.sort.last] if flood_fills.keys.size > 0

    # Fallback to RandomValid (likely run into own death)
    RandomValid.new(@context).move
  end
end