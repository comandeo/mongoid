# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Expression
      class FieldPath < Expression
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
