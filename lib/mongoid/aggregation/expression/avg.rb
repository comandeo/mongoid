# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'

module Mongoid
  module Aggregation
    class Expression
      class Avg < Expression

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
