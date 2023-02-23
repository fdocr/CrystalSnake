require "kemal"
require "../config"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

add_handler OpenTelemetryHandler.new if ENV["HONEYCOMB_API_KEY"]?.presence

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
  # BattleSnake::Record.create(game_id: context.game.id, context: env.params.json.to_json)
end

post "/move" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)

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

post "/end" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
end

get "/wat" do |env|
  # "WAT: #{BattleSnake::Record.select("COUNT(id) AS count").pluck(:count)}"
end

Kemal.run