# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Expression
      class Literal < Expression

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
