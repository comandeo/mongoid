# frozen_string_literal: true

module Mongoid
  module Aggregation
    class Builder
      def initialize(document_class, result_class)
        @document_class = document_class
        @result_class = result_class
        @stages = []
      end

      def build
        @stages.map(&:compile)
      end

      ##########
      # Stages #
      ##########
      def match
        @stages << Stage::Match.new(yield)
      end

      def group(&block)
        @stages << Stage::Group.new(&block)
      end

      def add_fields(&block)
        @stages << Stage::AddFields.new(&block)
      end

      def bucket(&block)
        @stages << Stage::Bucket.new(&block)
      end
    end
  end
end
