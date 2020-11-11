# frozen_string_literal: true

class TimeParser
  FORMAT_TYPES = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  attr_reader :types, :invalid_types

  def initialize(request)
    format_str     = request.params['format']
    @types         = format_str&.split(',') || []
    @invalid_types = @types - FORMAT_TYPES.keys
  end

  def success?
    @invalid_types.empty?
  end

  def body
    (Time.now.strftime(formatted_time_str) if @types.any? && @invalid_types.empty?).to_s
  end

  def error
    ("Unknown time format: #{@invalid_types}" if @invalid_types.any?).to_s
  end

  private

  def formatted_time_str
    FORMAT_TYPES.values_at(*@types).join('-')
  end
end
