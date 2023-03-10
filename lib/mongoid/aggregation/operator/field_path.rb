# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Operator
      class FieldPath < Operator
        def initialize(field_name)
          @field_path = "$#{field_name}"
        end

        def compile
          @field_path
        end
      end
    end
  end
end
