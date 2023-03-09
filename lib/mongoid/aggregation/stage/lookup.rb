# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Stage
      class Lookup < Stage
        def initialize(&block)
          instance_eval(&block)
        end

        def from(collection)
          @from = collection.to_s
        end

        def local_field(field)
          @local_field = field.to_s
        end

        def foreign_field(field)
          @foreign_field = field.to_s
        end

        def as(as)
          @as = as.to_s
        end

        def compile
          {
            '$lookup' => {
              'from' => @from,
              'localField' => @local_field,
              'foreignField' => @foreign_field,
              'as' => @as
            }
          }
        end
      end
    end
  end
end

