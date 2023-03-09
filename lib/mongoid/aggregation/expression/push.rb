# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'
require 'mongoid/aggregation/expression/literal'

module Mongoid
  module Aggregation
    class Expression
      class Push < Expression

        def initialize(expr = nil, &block)
          if expr.is_a?(Expression)
            @expr = expr
          else
            @fields = {}
            instance_eval(&block)
          end
        end

        def method_missing(method, *args, &block)
          @fields[method] = if block_given?
            instance_eval(&block)
          else
            args[0]
          end
        end

        def compile
          attrs = if @expr.nil?
            @fields.map { |k, v| [k, v.compile] }.to_h
          else
            @expr.compile
          end
          {
            '$push' => attrs
          }
        end
      end
    end
  end
end
