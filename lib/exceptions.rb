# frozen_string_literal: true

module Exceptions
  ResourceNotFound   = Class.new(StandardError)
  InvalidQueryFormat = Class.new(StandardError)
end
