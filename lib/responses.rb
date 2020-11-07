# frozen_string_literal: true

module Responses
  RESPONSE_CODES = {
    ok: 200,
    bad_request: 400,
    not_found: 404
  }.freeze

  RESPONSE_CODES.each do |name, code|
    define_method name do |headers = {}, body = []|
      [code, headers, body]
    end
  end
end
