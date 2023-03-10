# frozen_string_literal: true

require 'mongoid/aggregation/operator/literal'

module Mongoid
  module Aggregation
    class Operator
      class Sum < Operator

        def initialize(field = nil, &block)
          @expr = if field.nil?
            instance_eval(&block)
          elsif field.is_a?(Operator)
            field
          else
            Operator::Literal.new(field)
          end
        end

        def compile
          {
            '$sum' => if @expr.is_a?(Array)
              @expr.map(&:compile)
            else
              @expr.compile
            end
          }
        end
      end
    end
  end
end
