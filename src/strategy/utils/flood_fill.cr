require "priority-queue"

# Implementation of Flood Fill
# ([read more](https://en.wikipedia.org/wiki/Flood_fill)).
#
# It receives a BattleSnake::Point *a* and a BattleSnake::Context *context* to
# start off a Flood Fill and returns a Set(BattleSnake::Point) with all the
# points reachable to that area on the board
def Strategy::Utils.flood_fill(a : BattleSnake::Point, context : BattleSnake::Context)
  # p "Flood fill"
  area = Set(BattleSnake::Point).new
  queue = [] of BattleSnake::Point
  current = a

  loop do
    # Check all valid moves from current Point
    context.valid_moves(current)[:neighbors].each_value.each do |point|
      # p "Move #{point.inspect}"
      # Skip if already in area or in queue to be processed
      next unless area.index { |p| (p <=> point).zero? }.nil?
      next unless queue.index { |p| (p <=> point).zero? }.nil?

      # p "Adding to the queue #{point.inspect}"
      queue.push(point)
    end

    current = queue.pop
    # p "Checking #{current.inspect}"
    area.add(current) unless current.nil?

    break if queue.empty?
  end

  # p "Flood fill res count: #{area.size}"

  area
end