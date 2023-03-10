# frozen_string_literal: true

require 'mongoid/aggregation/operator/field_path'

module Mongoid
  module Aggregation
    class Operator
      class Avg < Operator

        def initialize(field = nil, &block)
          @expr = if field.nil?
            instance_eval(&block)
          else
            field
          end
        end

        def compile
          {
            '$avg' => @expr.compile
          }
        end
      end
    end
  end
end
