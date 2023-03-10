module Mongoid
  module Aggregation
    class Operator
      class Project < Operator
        def initialize(&block)
          @fields = {}
          instance_eval(&block)
        end

        def method_missing(method, *args, &block)
          @fields[method] = if block_given?
            instance_eval(&block)
          elsif args[0].is_a?(Operator)
            args[0]
          else
            Operator::Literal.new(args[0])
          end
        end

        def compile
          {
            '$project' => @fields.map { |k, v| [k, v.compile] }.to_h
          }
        end
      end
    end
  end
end
