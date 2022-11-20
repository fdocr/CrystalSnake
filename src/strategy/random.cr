class Strategy::Random < Strategy::Base
  def move
    ["up", "left", "down", "right"].sample
  end
end