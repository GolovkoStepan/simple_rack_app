# frozen_string_literal: true

require_relative 'lib/time_parser'

class Application
  ROUTES = { '/time' => TimeParser }.freeze

  def call(env)
    request = Rack::Request.new(env)

    if (service = ROUTES[request.path_info])
      result = service.new(request)
      result.success? ? response(200, result.body) : response(400, result.error)
    else
      response 404, "Resource not found: #{request.path_info}"
    end
  end

  private

  def response(status, body)
    Rack::Response.new([body], status, {}).finish
  end
end
