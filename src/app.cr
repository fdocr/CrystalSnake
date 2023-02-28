require "kemal"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
Dotenv.load if File.exists?(".env")

require "sidekiq"
require "./initializers/**"
require "./models/**"
require "./workers/**"

Sidekiq::Client.default_context = Sidekiq::Client::Context.new

macro persist_turn!
  PersistTurnWorker.async.perform(
    env.request.path,
    env.params.json.to_json
  )
end

def truncate_uuid(str)
  "#{str[0..7]}...#{str[24..32]}"
end

before_all do |env|
  env.response.content_type = "application/json" unless env.request.path =~ /\/games?/
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
  context = BattleSnake::Context.from_json(env.params.json.to_json)
  persist_turn!

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
  persist_turn!
end

get "/games" do |env|
  offset = (env.params.query["page"]? || 0).to_i * 50
  count = Turn.where { _path == "/end" }.count
  end_turns = Turn.where { _path == "/end" }.limit(50).offset(offset)
  render "src/views/games.ecr", "src/views/layout.ecr"
end

Kemal.run