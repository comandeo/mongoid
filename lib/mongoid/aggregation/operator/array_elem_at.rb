module Mongoid
  module Aggregation
    class Operator
      class ArrayElemAt < Operator
        def initialize(array, index)
          @array = if array.respond_to?(:call)
            instance_eval(&array)
          elsif array.is_a?(Operator)
            array
          else
            Operator::Literal.new(array)
          end
          @index = if index.respond_to?(:call)
            instance_eval(&index)
          elsif index.is_a?(Operator)
            index
          else
            Operator::Literal.new(index)
          end
        end

        def compile
          {
            '$arrayElemAt' => [@array.compile, @index.compile]
          }
        end
      end
    end
  end
end
