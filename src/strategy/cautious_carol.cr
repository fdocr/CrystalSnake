# Strategy that chases the closest available food from the board with caution
# against head-to-head collisions. When a potentially dangerous move is in the
# way it analyzes the other valid moves available and picks the one with the 
# most open area of the board to avoid enclosed spaces.
class Strategy::CautiousCarol < Strategy::Base
  def move
    valid_moves = @context.valid_moves(@context.you.head)
    return RandomValid.new(@context).move if valid_moves[:moves].empty?

    # Check for head-to-head collision possibilities
    dangerous_moves = [] of BattleSnake::Point
    enemies = @context.board.snakes.reject { |s| s.id == @context.you.id }
    enemies.each do |snake|
      next if snake.head <=> @context.you.head > 2
      next if snake.body.size < @context.you.body.size

      # Check if we share valid moves (meeting point for collision)
      @context.valid_moves(snake.head)[:neighbors].values.each do |point|
        meeting_point = valid_moves[:neighbors].values.find do |p|
          (point <=> p).zero?
        end
        next if meeting_point.nil?
        dangerous_moves << point
      end
    end

    # Attempt to chase closest food unless dangerous move is detected
    closest_food = ChaseClosestFood.new(@context).move
    target_point = @context.you.head.move(closest_food)
    safe_move = dangerous_moves.find { |p| (p <=> target_point).zero? }.nil?
    return closest_food if safe_move

    # Leftover valid moves (not chasing closest food anymore) & fallback to
    # RandomValid if no other moves are available (likely run into own death)
    safe_moves = valid_moves[:moves].reject { |move| move == closest_food }
    return RandomValid.new(@context).move if safe_moves.size.zero?

    # Use flood fill to pick the valid move with more space to spare as an 
    # attempt to avoid small areas
    flood_fills = {} of Int32 => String
    contexts = [] of BattleSnake::Context
    safe_moves.size.times { contexts << @context.dup }
    safe_moves.each_with_index do |move, i|
      contexts[i].move(@context.you.id, move)
      area_size = Utils.flood_fill(@context.you.head, contexts[i]).size
      flood_fills[area_size] = move
    end

    # Pick the direction with the largest available area
    flood_fills[flood_fills.keys.sort.last]
  end
end