# Implementation that returns all moves that could cause a collision with
# another snake which would result in death.
def Strategy::Utils.possible_collisions(context : BattleSnake::Context)
  valid_moves = context.valid_moves(context.you.head)
  dangerous_moves = [] of BattleSnake::Point

  context.enemies.each do |snake|
    # Snake is too far away to collide
    next if (snake.head <=> context.you.head) > 2
    # We're larger than the snake (not dangerous)
    next if snake.body.size < context.you.body.size

    # Check if we share valid moves (meeting point for collision)
    context.valid_moves(snake.head)[:neighbors].values.each do |point|
      meeting_point = valid_moves[:neighbors].values.find do |p|
        (point <=> p).zero?
      end
      next if meeting_point.nil?
      dangerous_moves << point
    end
  end

  dangerous_moves
end