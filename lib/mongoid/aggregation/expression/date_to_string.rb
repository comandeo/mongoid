# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'
require 'mongoid/aggregation/expression/literal'

module Mongoid
  module Aggregation
    class Expression
      class DateToString < Expression

        def initialize(date, format = nil, timezone = nil, on_null = nil)
          @date = if date.is_a?(Expression)
            date
          else
            instance_eval(&date)
          end
          @format = Expression::String.new(format) if format
          set_timezone(timezone)
          @on_null = instance_eval(&on_null) if on_null
        end

        def compile
          attrs = {
            date: @date.compile
          }
          attrs[:format] = @format.compile if @format
          attrs[:timezone] = @timezone.compile if @timezone
          attrs[:onNull] = @on_null.compile if @on_null
          {
            '$dateToString' => attrs
          }
        end

        private

        def set_timezone(timezone)
          return unless timezone

          @timezone = if timezone.respond_to?(:call)
            instance_eval(&timezone)
          else
            Expression::Literal.new(timezone)
          end
        end
      end
    end
  end
end
