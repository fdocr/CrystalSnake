# Abstract class of all strategies. They're all initialized with a *@context*
# and their entrypoint is the `#move` method
module Strategy
  VALID_MOVES = ["up", "left", "down", "right"]

  def self.build(name, context)
    case name
    when "random"
      Strategy::Random.new(context)
    when "random_valid"
      Strategy::RandomValid.new(context)
    when "blast_random_valid"
      Strategy::BlastRandomValid.new(context)
    when "chase_closest_food"
      Strategy::ChaseClosestFood.new(context)
    when "chase_random_food"
      Strategy::ChaseClosestFood.new(context)
    when "cautious_carol"
      Strategy::CautiousCarol.new(context)
    else
      nil
    end
  end

  abstract class Base
    @next_context : BattleSnake::Context

    def initialize(@context : BattleSnake::Context)
      @next_context = @context.dup
      @next_context.board.snakes.each { |snake| snake.body.pop }
      @next_context.you.body.pop
    end

    # Returns the move (direction) to chose based on the *@context*
    def move
      "up"
    end
  end
end