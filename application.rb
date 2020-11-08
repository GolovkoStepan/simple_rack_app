# frozen_string_literal: true

require_relative 'lib/responses'
require_relative 'lib/exceptions'
require_relative 'lib/time_parser'

class Application
  include Responses
  include Exceptions

  TARGET_ROUTE = '/time'

  def call(env)
    with_exception_handling do
      request = Rack::Request.new(env)
      raise ResourceNotFound, "Resource not found: #{request.path_info}" unless request.path_info == TARGET_ROUTE

      time_parser = TimeParser.new(request.params['format'])
      raise InvalidQueryFormat, "Unknown time format: #{time_parser.invalid_types}" if time_parser.invalid_types.any?

      ok({}, [time_parser.time.to_s])
    end
  end

  private

  def with_exception_handling
    yield
  rescue ResourceNotFound => e
    not_found({}, [e.message])
  rescue InvalidQueryFormat => e
    bad_request({}, [e.message])
  end
end
