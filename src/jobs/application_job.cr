require "mosquito"

# Base class for jobs in the app. Overrides `perform` so that jobs can
# implement `trace_perform` instead. This will allow for OpenTelemetry tracing
# if available, otherwise the job will be executed as it would if it overrides
# `perform` (mosquito standard). If someone does override `perform` on the job
# it will also have no behavior effect, other than tracing not taking place.
abstract class ApplicationJob < Mosquito::QueuedJob
  def perform
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