require "kemal"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
Dotenv.load if File.exists?(".env")
require "./initializers/**"
require "./models/**"

macro persist_turn!
  dead = context.board.snakes.find { |s| s.id == context.you.id }.nil?
  Turn.create(
    game_id: context.game.id,
    snake_id: context.you.id,
    context: env.params.json.to_json,
    path: env.request.path,
    dead: dead
  )
end

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do
  {
    "apiversion": "1",
    "author": "fdocr",
    "color": ENV["SNAKE_COLOR"] ||= "#e3dada",
    "head": ENV["SNAKE_HEAD"] ||= "default",
    "tail": ENV["SNAKE_TAIL"] ||= "default",
    "version": {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  }.to_json
end

post "/start" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  persist_turn!
end

post "/move" do |env|
  OpenTelemetry.trace "move-trace" do |span|
    span["debug-attr"] = "move-trace"
    context = BattleSnake::Context.from_json(env.params.json.to_json)
  
    OpenTelemetry.trace "context persist" do |span|
      span["debug-attr"] = "persist"
      persist_turn!
    end

    OpenTelemetry.trace "context persist" do |span|
      span["debug-attr"] = "move-logic"

      case ENV["STRATEGY"] ||= "RandomValid"
      when "RandomValid"
        move = Strategy::RandomValid.new(context).move
      when "ChaseClosestFood"
        move = Strategy::ChaseClosestFood.new(context).move
      when "ChaseRandomFood"
        move = Strategy::ChaseRandomFood.new(context).move
      when "CautiousCarol"
        move = Strategy::CautiousCarol.new(context).move
      else
        move = Strategy::RandomValid.new(context).move
      end
    
      res = { "move": move, "shout": "Moving #{move}!" }
      res.to_json
    end
  end
end

post "/end" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  persist_turn!
end

get "/wat" do |env|
  Turn.all.to_a.map { |r| r.game_id }.join(",")
end

Kemal.run