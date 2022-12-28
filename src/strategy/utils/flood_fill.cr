require "priority-queue"

# Implementation of Flood Fill
# ([read more](https://en.wikipedia.org/wiki/Flood_fill)).
#
# It receives a BattleSnake::Point *a* and a BattleSnake::Context *context* to
# start off a Flood Fill and returns a Set(BattleSnake::Point) with all the
# points reachable to that area on the board
def Strategy::Utils.flood_fill(a : BattleSnake::Point, context : BattleSnake::Context)
  area = Set(BattleSnake::Point).new
  queue = [a]

  # Iterate through the reachable area
  while queue.any?
    # Include current Point from queue
    current = queue.pop
    area.add(current)

    # Check all valid moves from current Point
    context.valid_moves(current)[:neighbors].each do |point|
      # Skip if already in consideration
      next if area.includes?(point) || queue.includes?(point)

      queue.push(point)
    end
  end

  area
end