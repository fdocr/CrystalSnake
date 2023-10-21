require "dotenv"
Dotenv.load if File.exists?(".env")
require "../config/**"

# Shainet
layer_neurons_opts = [35, 60, 75]
learning_rate_opts = [0.005, 0.2, 0.7]
momentum_opts = [0.05, 0.1, 0.3]
error_threshold = 0.0001
option_permutations = [] of Hash(Symbol, Float64)
27.times do |i|
  hash = Hash(Symbol, Float64).new
  hash[:neurons] = layer_neurons_opts[i % 3]
  hash[:learning_rate] = learning_rate_opts[(i / 3).to_i % 3]
  hash[:momentum] = momentum_opts[(i / 9).to_i % 3]
  option_permutations << hash
end

Log.info { "#{option_permutations.size} options" }
options_channel = Channel(Hash(Symbol, Float64)).new
complete_channel = Channel(Int32).new

5.times do |i|
  spawn do
    loop do
      [200, 1000, 15000].shuffle.each do |epochs|
        options = options_channel.receive
        log_name = "./nn_training/cc_nn_#{options[:neurons].to_i}n_#{options[:learning_rate]}l_#{options[:momentum]}m_#{epochs}e_#{error_threshold}t.log"
        command = "./train_network -n #{options[:neurons].to_i} -l #{options[:learning_rate]} -m #{options[:momentum]} -e #{epochs} -t #{error_threshold} | tee #{log_name}"
        system command
      end

      complete_channel.send(i)
    end
  end
end

# Delivery permutations
spawn { option_permutations.shuffle.each { |options| options_channel.send(options) } }

# Wait for permutations processing
27.times do |i|
  res = complete_channel.receive
  Log.info { "[root] -> Finished processing from #{res}" }
end
