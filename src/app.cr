require "kemal"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do
  {
    "apiversion": "1",
    "author": "fdocr",
    "color": "#777777",
    "head": "default",
    "tail": "default",
    "version": {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  }.to_json
end

post "/start" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
end

post "/move" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  # move = Strategy::RandomValid.new(context).move
  move = Strategy::ChaseRandomFood.new(context).move
  # move = Strategy::ChaseClosestFood.new(context).move

  res = { "move": move, "shout": "Moving #{move}!" }
  res.to_json
end

post "/end" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
end

Kemal.run