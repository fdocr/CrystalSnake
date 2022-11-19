require "kemal"
require "./battle_snake/**"

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
  turn = env.params.json["turn"].as(Int)
  game = BattleSnake::Game.from_json(env.params.json["game"].to_json)
  board = BattleSnake::Board.from_json(env.params.json["board"].to_json)
  you = BattleSnake::Snake.from_json(env.params.json["you"].to_json)
end

post "/move" do |env|
  turn = env.params.json["turn"].as(Int)
  game = BattleSnake::Game.from_json(env.params.json["game"].to_json)
  board = BattleSnake::Board.from_json(env.params.json["board"].to_json)
  you = BattleSnake::Snake.from_json(env.params.json["you"].to_json)

  move = [ "up", "down", "left", "right" ].sample

  res = { "move": move, "shout": "Moving #{move}!" }

  puts "RES: #{res}"

  res.to_json
end

post "/end" do |env|
  turn = env.params.json["turn"].as(Int)
  game = BattleSnake::Game.from_json(env.params.json["game"].to_json)
  board = BattleSnake::Board.from_json(env.params.json["board"].to_json)
  you = BattleSnake::Snake.from_json(env.params.json["you"].to_json)

  puts "END (turn #{turn}): #{board.inspect} - #{you.inspect}"
end

Kemal.run