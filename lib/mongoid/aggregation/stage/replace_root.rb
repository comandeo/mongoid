module Mongoid
  module Aggregation
    class Stage
      class ReplaceRoot < Stage
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
