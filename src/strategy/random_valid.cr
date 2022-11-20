class Strategy::RandomValid < Strategy::Base
  def move
    return @context.valid_moves.sample unless @context.valid_moves.empty?

    # No valid moves available => move up
    "up"
  end
end