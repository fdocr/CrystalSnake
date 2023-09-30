require "kemal"
require "./l_tree"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
dev_env = Kemal.config.env == "development"
Dotenv.load if File.exists?(".env") && dev_env
test_env = Kemal.config.env == "test"
Dotenv.load(path: ".env.test") if File.exists?(".env.test") && test_env

require "../config/**"
require "./models/**"
require "./jobs/**"

add_context_storage_type(Strategy::Base)
persist_to_db = ENV["DISABLE_DB_PERSIST"]?.nil?
not_found_response = "
  <p style='margin-top: 100px;'>
    <center>
      Strategy Not Found.
      <br><br>
      <a href='https://github.com/fdocr/crystalsnake'>Read usage details</a>
    </center>
  </p>
"

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
  next if env.request.path =~ /\/games?/

  env.response.content_type = "application/json"
  next if env.params.json.empty?

  context = BattleSnake::Context.from_json(env.params.json.to_json)
  strategy = Strategy.build(env.params.url["strategy"], context)
  halt env, status_code: 404, response: not_found_response if strategy.nil?
  env.set("strategy", strategy)
end

get "/" do |env|
  env.redirect "https://github.com/fdocr/CrystalSnake"
end

# Battlesnake API Endpoints
get "/:strategy" do |env|
  {
    "apiversion": "1",
    "author": "fdocr",
    "color": ENV["SNAKE_COLOR"] ||= "#e3dada",
    "head": ENV["SNAKE_HEAD"] ||= "default",
    "tail": ENV["SNAKE_TAIL"] ||= "default",
    "version": {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  }.to_json
end

post "/:strategy/start" do |env|
  persist_turn!
end

post "/:strategy/move" do |env|
  persist_turn!
  move = env.get("strategy").as(Strategy::Base).move
  res = { "move": move, "shout": "Moving #{move}!" }
  res.to_json
end

post "/:strategy/end" do |env|
  persist_turn!
end

# DB-persisted games
get "/games/:strategy" do |env|
  strategy = env.params.url["strategy"]
  offset = (env.params.query["page"]? || 0).to_i * 50
  count = Turn.where { _path == "/#{strategy}/end" }.count
  end_turns = Turn.where { _path == "/#{strategy}/end" }.limit(50).offset(offset).order(id: :desc)
  render "src/views/games.ecr", "src/views/layout.ecr"
end

spawn { Mosquito::Runner.start } unless ENV["EMBED_WORKER"]?.nil?

Kemal.run