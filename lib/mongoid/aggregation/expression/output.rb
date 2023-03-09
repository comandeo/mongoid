# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Expression
      class Output < Expression

        def initialize(&block)
          @fields = {}
          instance_eval(&block)
        end

        def method_missing(method, *args, &block)
          @fields[method] = if block_given?
            instance_eval(&block)
          else
            args[0]
          end
        end

        def compile
          @fields.map { |k, v| [k, v.compile] }.to_h
        end
      end
    end
  end
end
