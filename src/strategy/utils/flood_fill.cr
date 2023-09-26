# Implementation of Flood Fill
# ([read more](https://en.wikipedia.org/wiki/Flood_fill)).
#
# It receives a BattleSnake::Point *a* and a BattleSnake::Context *context* to
# start off a Flood Fill and returns a Set(BattleSnake::Point) with all the
# points reachable to that area on the board
def Strategy::Utils.flood_fill(a : BattleSnake::Point, context : BattleSnake::Context)
  area = Set(BattleSnake::Point).new
  queue = [] of BattleSnake::Point
  current = a

  loop do
    # Check all valid moves from current Point
    context.valid_moves(current)[:neighbors].each_value.each do |point|
      # Skip if already in area or in queue to be processed
      next unless area.index { |p| (p <=> point).zero? }.nil?
      next unless queue.index { |p| (p <=> point).zero? }.nil?

      queue.push(point)
    end

    break if queue.empty?
    current = queue.pop
    area.add(current)
  end

  area
end