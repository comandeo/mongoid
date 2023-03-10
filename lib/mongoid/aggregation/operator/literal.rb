# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Operator
      class Literal < Operator

        def initialize(value)
          @value = value
        end

        def compile
          @value
        end
      end
    end
  end
end
