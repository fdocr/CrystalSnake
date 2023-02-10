require "opentelemetry"

class OpenTelemetryHandler < Kemal::Handler
  def call(context)
    OpenTelemetry.trace "crystal-snake" do |span|
      span.kind = :server
      span["http.server_name"] = context.request.headers["Host"]?
      span["http.client_ip"] = context.request.headers["x-forward-for"]? || context.request.remote_address.as(Socket::IPAddress).address
      span["http.user_agent"] = context.request.headers["user-agent"]?
      span["http.path"] = context.request.path
      span["http.method"] = context.request.method
      span["http.target"] = context.request.resource
      span["http.flavor"] = context.request.version
      span["http.host"] = context.request.headers["host"]?
      span["service.name"] = ENV["HONEYCOMB_DATASET"]
      context.request.query_params.each do |key, value|
        span["request.query_params.#{key}"] = value
      end

      begin
        call_next context
      ensure
        span["http.status_code"] = context.response.status_code.to_i64
        if context.response.status_code < 400
          span.status = OpenTelemetry::Proto::Trace::V1::Status.new(code: :ok)
        end
      end
    end
  end
end

if ENV["HONEYCOMB_API_KEY"]?.presence
  OpenTelemetry.configure do |c|
    c.exporter = OpenTelemetry::BatchExporter.new(
      OpenTelemetry::HTTPExporter.new(
        endpoint: URI.parse("https://api.honeycomb.io"),
        headers: HTTP::Headers{
          # Get your Honeycomb API key from https://ui.honeycomb.io/account
          "x-honeycomb-team"    => ENV["HONEYCOMB_API_KEY"]
        },
      )
    )
  end

  add_handler OpenTelemetryHandler.new
end
