require "priority-queue"

def Strategy::Utils.a_star(a : BattleSnake::Point, b : BattleSnake::Point, context : BattleSnake::Context)
  queue = Priority::Queue(BattleSnake::Point).new
  came_from = {} of BattleSnake::Point => BattleSnake::Point
  node_distance = {} of BattleSnake::Point => Int32

  node_distance[a] = a <=> b
  queue.push(node_distance[a], a)
  finished = false

  while !finished
    current = queue.shift.value
    valid_moves = context.valid_moves(current)

    valid_moves[:moves].each do |move|
      new_point = valid_moves[:neighbors][move]
      next if node_distance.has_key?(new_point)

      node_distance[new_point] = new_point <=> b
      queue.push(node_distance[new_point], new_point)
      came_from[new_point] = current
      finished = true if node_distance[new_point].zero?
    end

    break if !finished && queue.count { true }.zero?
  end

  route = [] of BattleSnake::Point
  moves = [] of String
  return { route: route, moves: moves } unless finished

  puts "FINISHEDDDD: #{came_from.inspect}"

  current = b
  while current != a
    puts "current [#{current.to_s}]"
    route.unshift(current)

    # Creo que el error aqui aparece porque los puntos no son los mismos objetos y el hash[key] no utiliza el Comparable para hacer el O(1) access :/
    moves.unshift(came_from[current].move?(current))
    current = came_from[current]
  end

  puts "LOL (#{{ route: route, moves: moves }})"
  { route: route, moves: moves }
end