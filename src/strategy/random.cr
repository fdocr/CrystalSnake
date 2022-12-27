# A strategy that chooses a random direction to move without any considerations
class Strategy::Random < Strategy::Base
  def move
    ["up", "left", "down", "right"].sample
  end
end