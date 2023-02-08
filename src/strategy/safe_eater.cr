# Strategy that chases randomly selected food from the board
class Strategy::SafeEater < Strategy::Base
  def move(steps = 1)
    # p "Starting SafeEater#move"
    enemies = @context.board.snakes.reject { |s| s.id == @context.you.id }
    enemy_count = enemies.size

    contexts = [] of BattleSnake::Context
    directions = ["up", "left", "down", "right"]
    permutations = (4 &** enemy_count)
    permutations.times { contexts << @context.dup }

    # p "Moving each permutation (#{permutations}) of enemies: #{enemies}"
    enemies.each_with_index do |enemy, i|
      directions.each_with_index do |dir, j|
        contexts.unsafe_fetch(i + (j * enemy_count)).move(enemy.id, dir)
      end
    end

    # Check available area of possible/valid moves vs all enemy permutations
    available_area = {} of Int32 => String
    if @context.board.food.empty?
      # p "There's no food [#{@context.you.head.inspect}]"
      # There's no food on the board. Move around but look out for tight places
      valid_moves = @context.valid_moves(@context.you.head)[:moves]
      # p "Valid moves: #{valid_moves}"
      valid_moves.each do |move|
        # p "evaluating move: #{move.inspect}"
        contexts.each do |c|
          # Simulate a direction
          result = c.dup
          result.move(@context.you.id, move)
          result.check_collisions

          # If we die in this scenario there's no point in moving forward
          next unless result.board.living?(@context.you.id)

          # # Check available area
          area = Utils.flood_fill(result.you.head, result)
          p "AREA: #{area.inspect}"
          available_area[area.size] = move
        end
      end
    else
      # p "There's food [#{@context.you.head.inspect}]"
      # There's food on the board. Chase after it but look out for tight spaces
      @context.board.food.each do |food|
        # p "Evaluating food: #{food.inspect}"
        # Find path to food element
        res = Utils.a_star(@context.you.head, food, @context)
        # p "A* result length: #{res[:moves].size}"
        contexts.each_with_index do |c, index|
          next if res[:moves].empty?

          # p "simulating move"
          # Simulate the move chosen (A* path towards food)
          target_move = res[:moves].first
          result = c.dup
          result.move(@context.you.id, target_move)
          result.check_collisions

          # If we die in this scenario there's no point in moving forward
          next unless result.board.living?(@context.you.id)

          # p "calculating area"

          # Calculate flood fill from result state to see how "trapped" are we
          area = Utils.flood_fill(@context.you.head.move(target_move), result)
          # p "AREA: #{area.inspect}"
          available_area[area.size] = target_move
        end
      end
    end

    # p "Okay?"

    # I want to avoid being trapped so area must be larger than the snake itself
    sorted_areas = available_area.keys.sort
    snake_length = @context.you.body.size
    p "Sorted Areas (#{snake_length}): #{sorted_areas}"

    safe_areas = sorted_areas.select { |area| area > snake_length }
    p "Safe areas: #{safe_areas}"
    unsafe_areas = sorted_areas.select { |area| area <= snake_length }
    p "Unsafe areas: #{safe_areas}"

    safe_moves = safe_areas.map { |area| available_area[area] }.uniq
    p "Safe moves: #{safe_moves}"
    unsafe_moves = unsafe_areas.map { |area| available_area[area] }.uniq
    p "Unsafe moves: #{unsafe_moves}"

    # Return safe move if possible
    return safe_moves.first? if safe_moves.first?
    # Return unsafe move if possible
    return unsafe_moves.first? if unsafe_moves.first?

    # RandomValid fallback
    p "All this effort and CPU cycles just to go with RandomValid lol"
    Strategy::RandomValid.new(@context).move
  end
end