# frozen_string_literal: true

require 'mongoid/aggregation/operator/field_path'
require 'mongoid/aggregation/operator/literal'

module Mongoid
  module Aggregation
    class Operator
      class Concat < Operator

        def initialize(*args)
          @args = args.map do |arg|
            if arg.is_a?(Operator)
              arg
            elsif arg.respond_to?(:call)
              instance_eval(&arg)
            else
              Operator::Literal.new(arg)
            end
          end

        end

        def compile
          {
            '$concat' => @args.map(&:compile)
          }
        end
      end
    end
  end
end
