class Strategy::ChaseFood < Strategy::Base
  def move
    res = Utils.a_star(BattleSnake::Point.new(3,3), BattleSnake::Point.new(3,6), @context)

    puts "A* result: #{res.inspect}"

    # No valid moves available => move up
    "up"
  end
end