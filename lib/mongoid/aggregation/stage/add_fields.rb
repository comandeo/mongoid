# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Stage
      class AddFields < Stage
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

        def respond_to_missing?(_method, _include_private = false)
          true
        end

        def compile
          {
            '$addFields' => @fields.map { |k, v| [k, v.compile] }.to_h
          }
        end
      end
    end
  end
end

