# A strategy that chooses a random valid move, or "up" if there isn't any.
# Instead of the plain `BattleSnake::Conext::valid_moves` this strategy
# uses `BattleSnake::Conext::valid_moves` for a smarter choice if possible.
class Strategy::BlastRandomValid < Strategy::Base
  def move
    valid_moves = @context.blast_valid_moves!
    return valid_moves[:moves].sample unless valid_moves[:moves].empty?
    return valid_moves[:risky_moves].sample unless valid_moves[:risky_moves].empty?

    # No valid moves available => move up
    "up"
  end
end