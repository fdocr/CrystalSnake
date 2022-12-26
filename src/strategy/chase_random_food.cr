class Strategy::ChaseRandomFood < Strategy::Base
  def move
    # Chase a random food
    res = Utils.a_star(@context.you.head, @context.board.food.sample, @context)

    puts "A* result: #{res.inspect}"

    # Use A* move if possible
    return res[:moves].first unless res[:moves].empty?

    # RandomValid fallback
    Strategy::RandomValid.new(@context).move
  end
end