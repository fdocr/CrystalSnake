require "shainet"

# Strategy that chases the closest available food from the board with caution
# against head-to-head collisions. When a potentially dangerous move is in the
# way it analyzes the other valid moves available and picks the one with the 
# most open area of the board to avoid enclosed spaces.
class Strategy::CautiousCarolNeuralNetwork < Strategy::Base
  def move
    cc_nn = SHAInet::Network.new
    cc_nn.load_from_file("./src/cc_nn.nn")
    results = {} of String => Float64
    cc_nn.run(@context.to_nn_input).each_with_index do |result, index|
      results[VALID_MOVES[index]] = result
    end

    sorted_keys = results.keys.sort do |a,b|
      results[a] <=> results[b]
    end
    
    Log.info { "Result move: #{sorted_keys.first}" }
    sorted_keys.first
  end
end