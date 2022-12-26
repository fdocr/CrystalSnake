require "priority-queue"

def Strategy::Utils.a_star(a : BattleSnake::Point, b : BattleSnake::Point, context : BattleSnake::Context)
  queue = Priority::Queue(BattleSnake::Point).new
  came_from = {} of String => BattleSnake::Point
  node_distance = {} of String => Int32

  node_distance[a.to_s] = a <=> b
  queue.push(node_distance[a.to_s], a)
  finished = false

  # Solve A*
  while !finished
    current = queue.shift.value
    valid_moves = context.valid_moves(current)

    valid_moves[:moves].each do |move|
      new_point = valid_moves[:neighbors][move]
      next if node_distance.has_key?(new_point.to_s)

      node_distance[new_point.to_s] = new_point <=> b
      queue.push(node_distance[new_point.to_s], new_point)
      came_from[new_point.to_s] = current
      finished = true if node_distance[new_point.to_s].zero?
    end

    break if !finished && queue.count { true }.zero?
  end

  route = [] of BattleSnake::Point
  moves = [] of String
  return { route: route, moves: moves } unless finished

  # Backtrack to find the route
  current = b
  while current != a
    route.unshift(current)
    moves.unshift(came_from[current.to_s].move?(current))
    current = came_from[current.to_s]
  end

  { route: route, moves: moves }
end