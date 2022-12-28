require "./spec_helper"

describe "Crystal Snake Server" do
  it "returns metadata on root path" do
    get "/"
    response.status_code.should eq 200
  end

  it "returns 200 on /start" do
    payload = File.read("./spec/fixtures/start.json")
    post "/start", body: payload, headers: HTTP::Headers{"Content-Type" => "application/json"}
    response.status_code.should eq 200
  end

  it "returns 200 on /move" do
    payload = File.read("./spec/fixtures/move.json")
    post "/move", body: payload, headers: HTTP::Headers{"Content-Type" => "application/json"}
    response.status_code.should eq 200
  end

  it "returns 200 on /end" do
    payload = File.read("./spec/fixtures/end.json")
    post "/end", body: payload, headers: HTTP::Headers{"Content-Type" => "application/json"}
    response.status_code.should eq 200
  end
end
