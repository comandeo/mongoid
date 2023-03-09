# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Stage
      class Match < Stage
        def initialize(criteria)
          @criteria = criteria
        end

        def compile
          { '$match' => @criteria.selector }
        end
      end
    end
  end
end

