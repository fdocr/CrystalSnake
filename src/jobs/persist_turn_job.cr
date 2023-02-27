require "mosquito"

class PersistTurnJob < ApplicationJob
  params(path : String, context_json : String)

  def trace_perform
    context = BattleSnake::Context.from_json(context_json)
    dead = context.board.snakes.find { |s| s.id == context.you.id }.nil?
    turn = Turn.create(
      game_id: context.game.id,
      snake_id: context.you.id,
      context: context_json,
      path: path,
      dead: dead
    )
  end
end