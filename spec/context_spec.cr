require "./spec_helper"

describe "BattleSnake::Context" do
  it "returns valid moves" do
    json = File.read("./spec/fixtures/start_small.json")
    context = BattleSnake::Context.from_json(json)
    context.valid_moves(context.you.head)[:moves].should eq(["left", "down", "right"])
  end

  it "should move a snake" do
    json = File.read("./spec/fixtures/start_small.json")
    context = BattleSnake::Context.from_json(json)
    
    context.move(context.you.id, "down")
    snake = context.board.snakes.find! { |snake| snake.id == context.you.id }

    snake.body.map(&.to_s).join("-").should eq("2,3-2,4-2,4")
    snake.head.to_s.should eq("2,3")
  end

  it "should detect a collision" do
    json = File.read("./spec/fixtures/collision_1.json")
    context = BattleSnake::Context.from_json(json)

    context.board.snakes.count { true }.should eq(2)
    context.check_collisions
    context.board.snakes.count { true }.should eq(1)
  end
end