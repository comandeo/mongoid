# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'
require 'mongoid/aggregation/expression/literal'

module Mongoid
  module Aggregation
    class Expression
      class Concat < Expression

        def initialize(*args)
          @args = args.map do |arg|
            if arg.is_a?(Expression)
              arg
            elsif arg.respond_to?(:call)
              instance_eval(&arg)
            else
              Expression::Literal.new(arg)
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
