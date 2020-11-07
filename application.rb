# frozen_string_literal: true

require_relative 'lib/responses'
require_relative 'lib/exceptions'
require_relative 'lib/time_parser'

class Application
  include Responses
  include Exceptions

  DEFAULT_HEADERS = { 'Content-Type' => 'text/plain' }.freeze
  TARGET_ROUTE    = '/time'

  def call(env)
    with_exception_handling do
      request = Rack::Request.new(env)
      raise ResourceNotFound, "Resource not found: #{request.path_info}" unless request.path_info == TARGET_ROUTE

      time_parser = TimeParser.new(request.params['format'])
      raise InvalidQueryFormat, "Unknown time format: #{time_parser.invalid_types}" if time_parser.invalid_types?

      ok(response_headers, [time_parser.time.to_s])
    end
  end

  private

  def response_headers(headers = {})
    DEFAULT_HEADERS.merge(headers)
  end

  def with_exception_handling
    yield
  rescue ResourceNotFound => e
    not_found(response_headers, [e.message])
  rescue InvalidQueryFormat => e
    bad_request(response_headers, [e.message])
  end
end
