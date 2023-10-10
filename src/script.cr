require "kemal"
require "./battle_snake/**"
require "./strategy/**"

require "dotenv"
dev_env = Kemal.config.env == "development"
Dotenv.load if File.exists?(".env") && dev_env

require "../config/database"
require "./models/**"
require "./jobs/**"

# Script goes here
require "shainet"
require "csv"

require "log"

Log.setup do |c|
  backend = Log::IOBackend.new

  c.bind "*", :debug, backend
end
pp "#{ENV["LOG_LEVEL"]}"

# Log.setup do |c|
#   backend = Log::IOBackend.new

#   c.bind("*", :info, backend)
#   c.bind("shainet.*", :info, backend)
# end

# # Structure data
# winners = [
#   "d462b861-2618-4b97-9e9c-db00d0ead3df",
#   "e632200d-d750-4d5e-9319-02d0fb25a45b",
#   "2eb95479-d44e-418b-b113-023e8ebe7f4b",
#   "68280646-7cb4-4ff9-a0ba-fe0355a2d32b",
#   "eba6258f-472f-44f4-93c2-fb8588b9e262",
#   "bb7f0499-b635-415f-a4d5-730fbfcab5a0"
# ]
# data = {
#   "up" => [] of Array(Int32 | String),
#   "left" => [] of Array(Int32 | String),
#   "down" => [] of Array(Int32 | String),
#   "right" => [] of Array(Int32 | String),
# }
# winners.each do |id|
#   turns = Turn.where { and(_path == "/cautious_carol/move", _game_id == id) }.to_a
#   turns.sort! do |a, b|
#     BattleSnake::Context.from_json(a.context).turn <=> BattleSnake::Context.from_json(b.context).turn
#   end
#   contexts = turns.map { |turn| BattleSnake::Context.from_json(turn.context) }
  
#   last_id = turns.last.id
#   turns.each_with_index do |turn, index|
#     next if turn.id == last_id

#     context = contexts[index]
#     head = context.you.head
#     next_head = contexts[index + 1].you.head
#     move = head.move?(next_head)
#     next unless data.keys.includes?(move)

#     turn_data = Array.new(121, 0.as(Int32 | String))
#     context.board.food.each do |food|
#       offset = food.x + (food.y * 11)
#       turn_data[offset] = 10
#     end

#     snake_counter = 100
#     context.you.body.each do |point|
#       offset = point.x + (point.y * 11)
#       turn_data[offset] = snake_counter
#       snake_counter += 1
#     end

#     context.enemies.each_with_index do |snake, index|
#       snake_counter = 200 + (index * 100)
#       snake.body.each do |point|
#         offset = point.x + (point.y * 11)
#         turn_data[offset] = snake_counter
#         snake_counter += 1
#       end
#       snake.body
#     end

#     data[move] << turn_data
#   end
# end

# pp "#{data["up"].size} up"
# pp "#{data["left"].size} left"
# pp "#{data["down"].size} down"
# pp "#{data["right"].size} right"

# result = CSV.build do |csv|
#   data.keys.each do |move|
#     data[move].each do |turn_data|
#       csv.row turn_data + [move]
#     end
#   end
# end
# File.write("winners_data.csv", result)


# Shainet
Log.info { "WAT" }
# Create a new Data object based on a CSV
data = SHAInet::Data.new_with_csv_input_target("winners_data.csv", 0..120, 121)

# Split the data in a training set and a test set
training_set, test_set = data.split(0.67)

# Initiate a new network
cc_nn = SHAInet::Network.new

# Add layers
cc_nn.add_layer(:input, 121, :memory, SHAInet.sigmoid)
cc_nn.add_layer(:hidden, 12, :memory, SHAInet.sigmoid)
cc_nn.add_layer(:output, 4, :memory, SHAInet.sigmoid)
cc_nn.fully_connect

# Adjust network parameters
cc_nn.learning_rate = 0.7
cc_nn.momentum = 0.3

# Train the network
cc_nn.train(
      data: training_set,
      training_type: :adam,
      cost_function: :mse,
      epochs: 20000,
      error_threshold: 0.000001,
      log_each: 1000)

# Test the network's performance
cc_nn.test(test_set)



# label = {
#   "setosa"     => [0.to_f64, 0.to_f64, 1.to_f64],
#   "versicolor" => [0.to_f64, 1.to_f64, 0.to_f64],
#   "virginica"  => [1.to_f64, 0.to_f64, 0.to_f64],
# }
# iris = SHAInet::Network.new
# iris.add_layer(:input, 4, :memory, SHAInet.sigmoid)
# iris.add_layer(:hidden, 4, :memory, SHAInet.sigmoid)
# iris.add_layer(:output, 3, :memory, SHAInet.sigmoid)
# iris.fully_connect

# # Get data from a local file
# outputs = Array(Array(Float64)).new
# inputs = Array(Array(Float64)).new
# CSV.each_row(File.read(__DIR__ + "winners_data.csv")) do |row|
#   row_arr = Array(Float64).new
#   row[0..-2].each do |num|
#     row_arr << num.to_f64
#   end
#   inputs << row_arr
#   outputs << label[row[-1]]
# end
# data = SHAInet::TrainingData.new(inputs, outputs)
# data.normalize_min_max

# training_data, test_data = data.split(0.9)

# iris.train_es(
#   data: training_data,
#   pool_size: 50,
#   learning_rate: 0.5,
#   sigma: 0.1,
#   cost_function: :c_ent,
#   epochs: 500,
#   mini_batch_size: 15,
#   error_threshold: 0.00000001,
#   log_each: 100,
#   show_slice: true)

# # Test the trained model
# correct = 0
# test_data.data.each do |data_point|
#   result = iris.run(data_point[0], stealth: true)
#   expected = data_point[1]
#   # puts "result: \t#{result.map { |x| x.round(5) }}"
#   # puts "expected: \t#{expected}"
#   error_sum = 0.0
#   result.size.times do |i|
#     error_sum += (result[i] - expected[i]).abs
#   end
#   correct += 1 if error_sum < 0.3
# end
# puts "Correct answers: (#{correct} / #{test_data.size})"
# (correct > 10).should eq(true)






# # Find winners/losers
# turns = Turn.where { _path == "/cautious_carol/end" }.to_a
# winners = [] of String
# losers = [] of String
# pp turns.size
# turns.each do |turn|
#   context = BattleSnake::Context.from_json(turn.context)
#   if context.won?
#     winners << turn.game_id
#   elsif context.lost?
#     losers << turn.game_id
#   else
#     pp "Something went wrong! #{turn.game_id}"
#   end
# end

# pp "Winners:"
# winners.each do |id|
#   pp id
# end

# pp "Losers:"
# losers.each do |id|
#   pp id
# end