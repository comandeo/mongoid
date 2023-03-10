# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Operator
      class Match < Operator
        def initialize(&block)
          @criteria = Mongoid::Criteria.new(criteria_class).instance_eval(&block)
        end

        def compile
          { '$match' => @criteria.selector }
        end

        def criteria_class
          @criteria_class ||= Class.new do
            include Mongoid::Document
          end
        end
      end
    end
  end
end

