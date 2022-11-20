abstract class Strategy::Base
  def initialize(@context : BattleSnake::Context)
  end

  def move
    "up"
  end
end