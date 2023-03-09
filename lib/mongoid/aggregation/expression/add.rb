# frozen_string_literal: true

require 'mongoid/aggregation/expression/field_path'

module Mongoid
  module Aggregation
    class Expression
      class Add < Expression

        def initialize(*args)
          @args = args.map do |arg|
            if arg.is_a?(Expression)
              arg
            else
              instance_eval(&arg)
            end
          end

        end

        def compile
          {
            '$add' => @args.map(&:compile)
          }
        end
      end
    end
  end
end
