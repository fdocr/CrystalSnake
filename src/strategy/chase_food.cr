class Strategy::ChaseFood < Strategy::Base
  def move
    res = Utils.a_star(@context.you.head, @context.board.food.first, @context)

    puts "A* result: #{res.inspect}"

    # Use A* move if possible
    return res[:moves].first unless res[:moves].empty?

    # RandomValid fallback
    Strategy::RandomValid.new(@context).move
  end
end