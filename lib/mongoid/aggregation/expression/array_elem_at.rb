module Mongoid
  module Aggregation
    class Expression
      class ArrayElemAt < Expression
        def initialize(array, index)
          @array = if array.respond_to?(:call)
            instance_eval(&array)
          elsif array.is_a?(Expression)
            array
          else
            Expression::Literal.new(array)
          end
          @index = if index.respond_to?(:call)
            instance_eval(&index)
          elsif index.is_a?(Expression)
            index
          else
            Expression::Literal.new(index)
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
