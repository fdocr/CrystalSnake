require "mosquito"

abstract class ApplicationJob < Mosquito::QueuedJob
  def perform
    OpenTelemetry.trace self.class.to_s do |span|
      span.kind = :internal
      trace_perform
    end
  end
end