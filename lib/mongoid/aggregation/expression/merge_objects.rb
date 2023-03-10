module Mongoid
  module Aggregation
    class Expression
      class MergeObjects < Expression
        def initialize(*args)
          @args = args.map do |arg|
            if arg.respond_to?(:call)
              instance_eval(&arg)
            elsif arg.is_a?(Expression)
              arg
            else
              Expression::Literal.new(arg)
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
