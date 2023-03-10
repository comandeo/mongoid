module Mongoid
  module Aggregation
    class Operator
      class MergeObjects < Operator
        def initialize(*args)
          @args = args.map do |arg|
            if arg.respond_to?(:call)
              instance_eval(&arg)
            elsif arg.is_a?(Operator)
              arg
            else
              Operator::Literal.new(arg)
            end
          end
        end

        def compile
          {
            '$mergeObjects' => @args.map(&:compile)
          }
        end
      end
    end
  end
end
