module Mongoid
  module Aggregation
    class Operator
      class ReplaceRoot < Operator
        def initialize(&block)
          @replacement = instance_eval(&block)
        end
      end

      def compile
        {
          '$replaceRoot' => {
            'newRoot' => @replacement.compile
          }
        }
      end
    end
  end
end
