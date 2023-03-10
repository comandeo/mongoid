# frozen_string_literal: true

require 'mongoid/aggregation/operators'

module Mongoid
  module Aggregation
    class Builder
      include Operators

      def initialize(document_class, result_class)
        @document_class = document_class
        @result_class = result_class
        @stages = []
      end

      def build
        @stages.map(&:compile)
      end
    end
  end
end
