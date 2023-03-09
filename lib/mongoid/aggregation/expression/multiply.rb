# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Expression
      class Multiply < Expression

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
            '$multiply' => @args.map(&:compile)
          }
        end
      end
    end
  end
end
