# frozen_string_literal: true

require 'mongoid/aggregation/expression/literal'

module Mongoid
  module Aggregation
    class Expression
      class Sum < Expression

        def initialize(field = nil, &block)
          @expr = if field.nil?
            instance_eval(&block)
          else
            Expression::Literal.new(field)
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
