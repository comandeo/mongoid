# frozen_string_literal: true

require 'mongoid/aggregation/expression/output'

module Mongoid
  module Aggregation
    class Stage
      class Bucket < Stage
        def initialize(&block)
          @fields = {}
          instance_eval(&block)
        end

        def group_by(expr)
          @group_by = expr
        end

        def boundaries(boundaries)
          @boundaries = boundaries
        end

        def default(default)
          @default = default
        end

        def output(&block)
          @output = Expression::Output.new(&block)
        end

        def compile
          attrs = {
            'groupBy' => @group_by.compile,
            'boundaries' => @boundaries,
            'default' => @default
          }
          attrs['output'] = @output.compile if @output
          {
            '$bucket' => attrs
          }
        end
      end
    end
  end
end

