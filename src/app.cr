require "kemal"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
Dotenv.load if File.exists?(".env")
require "../config/**"
require "./models/**"
require "./jobs/**"

persist_to_db = ENV["DISABLE_DB_PERSIST"]?.nil?
selected_strategy = ENV["STRATEGY"] ||= "RandomValid"
Log.info { "Selected strategy: #{selected_strategy}" }

macro persist_turn!
  PersistTurnJob.new(
    path: env.request.path,
    context_json: env.params.json.to_json
  ).enqueue if persist_to_db
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

  case selected_strategy
  when "RandomValid"
    move = Strategy::RandomValid.new(context).move
  when "BlastRandomValid"
    move = Strategy::BlastRandomValid.new(context).move
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
  end_turns = Turn.where { _path == "/end" }.limit(50).offset(offset).order(id: :desc)
  render "src/views/games.ecr", "src/views/layout.ecr"
end

Kemal.run