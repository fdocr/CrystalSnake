# Strategy that chases the closest food from the board from You
class Strategy::ChaseClosestFood < Strategy::Base
  def move
    # Calculate the A* distance of all available food on the current context
    food_routes = {} of Int32 => NamedTuple(route: Array(BattleSnake::Point), moves: Array(String))
    @context.board.food.each do |point|
      res = Utils.a_star(@context.you.head, point, @context)
      dist = res[:moves].count { true }
      food_routes[dist] = res if dist > 0 
    end

    # Use RandomValid if there's no available food at play
    valid_target_count = food_routes.keys.count { true }.zero?
    return Strategy::RandomValid.new(@context).move if valid_target_count

    # Find the closest A* result and use their first move
    closest_dist = food_routes.keys.sort.first
    return food_routes[closest_dist][:moves].first
  end
end