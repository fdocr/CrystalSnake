# Strategy that chases the closest available food from the board while trying
# to avoid risky moves. It analyzes available moves to pick those with the most
# open area on the board to avoid enclosed spaces.
class Strategy::LookaheadLarry < Strategy::Base
  def move
    possible_moves = @context.blast_valid_moves!
    p "Possible moves: #{possible_moves}"
    if possible_moves[:moves].empty? && possible_moves[:risky_moves].empty?
      return RandomValid.new(@context).move
    end 

    # Attempt to chase closest food if not risky or small flood_fill result
    closest_food = ChaseClosestFood.new(@context).move
    p "Closest: #{closest_food}"
    not_risky_move = possible_moves[:moves].includes?(closest_food)
    closest_food_context = @context.dup
    closest_food_context.move(@context.you.id, closest_food)
    p "MOVED: #{@context.you.to_json}"
    closest_food_area_size = Utils.flood_fill(@context.you.head, closest_food_context).size
    is_safe_size = (closest_food_area_size >= @context.you.body.size)
    return closest_food if not_risky_move && is_safe_size

    # Use flood fill to pick the valid move with more space to spare as an 
    # attempt to avoid small areas
    safe_moves = possible_moves[:moves].reject { |move| move == closest_food }
    safe_flood_fills = {} of Int32 => String
    safe_contexts = [] of BattleSnake::Context
    safe_moves.size.times { safe_contexts << @context.dup }
    if safe_moves.size > 0
      safe_moves.each_with_index do |move, i|
        safe_contexts[i].move(@context.you.id, move)
        area_size = Utils.flood_fill(@context.you.head, safe_contexts[i]).size
        safe_flood_fills[area_size] = move
      end

      # Return safe move with large enough space
      largest_size = safe_flood_fills.keys.sort.last
      return safe_flood_fills[largest_size] if largest_size >= @context.you.body.size
    end

    # Use flood fill to check if risky moves have more space to spare as an 
    # attempt to avoid small areas
    risky_moves = possible_moves[:risky_moves].reject { |move| move == closest_food }
    risky_flood_fills = {} of Int32 => String
    risky_contexts = [] of BattleSnake::Context
    if risky_moves.size > 0
      risky_moves.each_with_index do |move, i|
        risky_contexts[i].move(@context.you.id, move)
        area_size = Utils.flood_fill(@context.you.head, risky_contexts[i]).size
        risky_flood_fills[area_size] = move
      end

      # Return risky move with large enough space
      largest_size = risky_flood_fills.keys.sort.last
      return risky_flood_fills[largest_size] if largest_size >= @context.you.body.size
    end

    # No safe/risky move has large enough flood_fill size to be safe. Fallback
    # to largest possible safe_move, risky_move, or just RandomValid as default
    if safe_moves.size > 0
      safe_flood_fills[safe_flood_fills.keys.sort.last]
    elsif risky_moves.size > 0
      risky_flood_fills[risky_flood_fills.keys.sort.last]
    else
      RandomValid.new(@context).move
    end
  end
end