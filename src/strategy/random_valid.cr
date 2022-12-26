class Strategy::RandomValid < Strategy::Base
  def move
    valid_moves = @context.valid_moves(@context.you.head)[:moves]
    return valid_moves.sample unless valid_moves.empty?

    # No valid moves available => move up
    "up"
  end
end