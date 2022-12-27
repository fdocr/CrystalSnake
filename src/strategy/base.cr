# Abstract class of all strategies. They're all initialized with a *@context*
# and their entrypoint is the `#move` method
abstract class Strategy::Base
  def initialize(@context : BattleSnake::Context)
  end

  # Returns the move (direction) to chose based on the *@context*
  def move
    "up"
  end
end