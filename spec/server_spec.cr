require "./spec_helper"

request_headers = HTTP::Headers{"Content-Type" => "application/json"}
SUPPORTED_STRATEGIES = [
  "random",
  "random_valid",
  "blast_random_valid",
  "chase_closest_food",
  "chase_random_food",
  "cautious_carol",
  "cc_nn"
]

describe "Crystal Snake Battlesnake endpoints for all supported strategies" do
  it "responds with metadata for all supported strategies" do
    SUPPORTED_STRATEGIES.each do |strategy_name|
      get "/#{strategy_name}"
      response.status_code.should eq 200
      res = Hash(String, String).from_json(response.body)
      res.keys.should eq(["apiversion", "author", "color", "head", "tail", "version"])
    end
  end

  it "returns 200 on /start" do
    SUPPORTED_STRATEGIES.each do |strategy_name|
      payload = File.read("./spec/fixtures/start.json")
      post "/#{strategy_name}/start", body: payload, headers: request_headers
      response.status_code.should eq 200
    end
  end

  it "returns 200 and valid move on /move" do
    SUPPORTED_STRATEGIES.each do |strategy_name|
      payload = File.read("./spec/fixtures/move.json")
      post "/#{strategy_name}/move", body: payload, headers: request_headers
      response.status_code.should eq 200
      selected_move = Hash(String, String).from_json(response.body)["move"]
      (Strategy::VALID_MOVES.includes?(selected_move)).should be_true
    end
  end

  it "returns 200 on /end" do
    SUPPORTED_STRATEGIES.each do |strategy_name|
      payload = File.read("./spec/fixtures/end.json")
      post "/#{strategy_name}/end", body: payload, headers: HTTP::Headers{"Content-Type" => "application/json"}
      response.status_code.should eq 200
    end
  end
end
