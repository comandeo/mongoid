# frozen_string_literal: true

require 'mongoid/aggregation/operator/field_path'
require 'mongoid/aggregation/operator/literal'

module Mongoid
  module Aggregation
    class Operator
      class DateToString < Operator

        def initialize(date, format = nil, timezone = nil, on_null = nil)
          @date = if date.is_a?(Operator)
            date
          else
            instance_eval(&date)
          end
          @format = Operator::Literal.new(format) if format
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
            Operator::Literal.new(timezone)
          end
        end
      end
    end
  end
end
