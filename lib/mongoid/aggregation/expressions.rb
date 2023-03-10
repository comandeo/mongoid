# frozen_string_literal: true

module Mongoid
  module Aggregation
    module Expressions
      def sum(field = nil, &block)
        Expression::Sum.new(field, &block)
      end

      def date_to_string(opts = {})
        Expression::DateToString.new(opts[:date], opts[:format], opts[:timezone], opts[:on_null])
      end

      def multiply(*args)
        Expression::Multiply.new(*args)
      end

      def avg(field = nil, &block)
        Expression::Avg.new(field, &block)
      end

      def add(*args)
        Expression::Add.new(*args)
      end

      def concat(*args)
        Expression::Concat.new(*args)
      end

      def field(field_name)
        Expression::FieldPath.new(field_name)
      end

      def push(*args, &block)
        Expression::Push.new(*args, &block)
      end

      def array_elem_at(field, index)
        Expression::ArrayElemAt.new(field, index)
      end

      def merge_objects(*args)
        Expression::MergeObjects.new(*args)
      end
    end
  end
end

