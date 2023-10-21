require "option_parser"
require "shainet"
require "log"

neurons = 10_i32
learning_rate = 0.7_f64
momentum = 0.3_f64
epochs = 200_i32
error_threshold = 0.0001_f64

option_parser = OptionParser.parse do |parser|
  parser.banner = "Train SHAInet Neural Network"

  parser.on "-v", "--version", "Show version" do
    puts "version 0.1"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on "-n NEURONS", "Number of neurons to use in hidden layer (default is 10)" do |count|
    neurons = count.to_i32
  end
  parser.on "-l LEARNING_RATE", "Learning rate to use for training (default is 0.7)" do |rate|
    learning_rate = rate.to_f64
  end
  parser.on "-m MOMENTUM", "Momentum rate to use for training (default is 0.3)" do |rate|
    momentum = rate.to_f64
  end
  parser.on "-e EPOCHS", "Epochs to use for training (default is 20,000)" do |count|
    epochs = count.to_i32
  end
  parser.on "-t ERROR_THRESHOLD", "Error threshold to use for training (default is 0.0001)" do |threshold|
    error_threshold = threshold.to_f64
  end
end

def train_network(training_type, neurons, learning_rate, momentum, epochs, error_threshold)
  Log.info { "#{training_type.to_s} training type (#{neurons}, #{learning_rate}, #{momentum}, #{epochs}, #{error_threshold})" }
  data = SHAInet::Data.new_with_csv_input_target("winners_data.csv", 0..120, 121)

  # Split the data in a training set and a test set
  training_set, test_set = data.split(0.67)

  # Initiate a new network
  cc_nn = SHAInet::Network.new

  # Add layers
  cc_nn.add_layer(:input, 121, :memory, SHAInet.sigmoid)
  cc_nn.add_layer(:hidden, neurons, :memory, SHAInet.sigmoid)
  cc_nn.add_layer(:output, 4, :memory, SHAInet.sigmoid)
  cc_nn.fully_connect

  # Adjust network parameters
  cc_nn.learning_rate = learning_rate
  cc_nn.momentum = momentum

  # Train the network
  cc_nn.train(
    data: training_set,
    training_type: training_type,
    cost_function: :mse,
    epochs: epochs,
    error_threshold: error_threshold,
    log_each: epochs >= 500 ? 250 : 10
  )

  filename = "./nn_training/cc_nn_#{training_type.to_s}_#{neurons}n_#{learning_rate}l_#{momentum}m_#{epochs}e_#{error_threshold}t.nn"
  cc_nn.save_to_file("./#{filename}")

  # Test the network's performance
  cc_nn.test(test_set)
  Log.info { "Network saved as: #{filename}" }
end

train_network(:sgdm, neurons, learning_rate, momentum, epochs, error_threshold)