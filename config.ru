# frozen_string_literal: true

require_relative 'application'

use Rack::ContentType, "text/plain"

run Application.new
