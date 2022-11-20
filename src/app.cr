require "kemal"
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
    "version": "0.0.1-beta"
  }.to_json
end

post "/start" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
end

post "/move" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  move = Strategy::RandomValid.new(context).move

  res = { "move": move, "shout": "Moving #{move}!" }
  puts "RESPONSE: #{res}"
  res.to_json
end

post "/end" do |env|
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  puts "END CONTEXT: #{context.inspect}"
end

Kemal.run