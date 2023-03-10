module Mongoid
  module Aggregation
    class Operator
      class Set < Operator
        def initialize(&block)
          @fields = {}
          instance_eval(&block)
        end

        def method_missing(name, *args, &block)
          @fields[name] = if block_given?
            instance_eval(&block)
          elsif args.first.is_a?(Operator)
            args.first
          else
            Operator::Literal.new(args.first)
          end
        end

        def compile
          {
            '$set' => @fields.map { |k, v| [k, v.compile] }.to_h
          }
        end
      end
    end
  end
end
