# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'

module Mongoid
  module Aggregation
    class Stage
      class Group < Stage
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
          {
            '$group' => @fields.map { |k, v| [k, v.compile] }.to_h
          }
        end
      end
    end
  end
end

