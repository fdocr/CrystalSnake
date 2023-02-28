require "mosquito"

abstract class ApplicationJob < Mosquito::QueuedJob
  def perform
    p "Mosquito"
    if ENV["HONEYCOMB_API_KEY"]?.presence
      OpenTelemetry.trace self.class.to_s do |span|
        span.kind = :internal
        trace_perform
      end
    else
      trace_perform
    end
  end
end