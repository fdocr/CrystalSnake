# A strategy that chooses a random direction to move without any considerations
class Strategy::Random < Strategy::Base
  def move
    VALID_MOVES.sample
  end
end