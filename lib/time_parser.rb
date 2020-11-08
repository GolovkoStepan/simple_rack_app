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

  def initialize(query_str)
    @types         = query_str&.split(',') || []
    @invalid_types = @types - FORMAT_TYPES.keys
  end

  def time
    Time.now.strftime(formatted_time_str) if @types.any? && @invalid_types.empty?
  end

  private

  def formatted_time_str
    FORMAT_TYPES.values_at(*@types).join('-')
  end
end
