# frozen_string_literal: true

module Mongoid
  module Aggregation
    module Operators
      def sum(field = nil, &block)
        Operator::Sum.new(field, &block)
      end

      def date_to_string(opts = {})
        Operator::DateToString.new(opts[:date], opts[:format], opts[:timezone], opts[:on_null])
      end

      def multiply(*args)
        Operator::Multiply.new(*args)
      end

      def avg(field = nil, &block)
        Operator::Avg.new(field, &block)
      end

      def add(*args)
        Operator::Add.new(*args)
      end

      def concat(*args)
        Operator::Concat.new(*args)
      end

      def field(field_name)
        Operator::FieldPath.new(field_name)
      end

      def push(*args, &block)
        Operator::Push.new(*args, &block)
      end

      def array_elem_at(field, index)
        Operator::ArrayElemAt.new(field, index)
      end

      def merge_objects(*args)
        Operator::MergeObjects.new(*args)
      end

      def match(&block)
        @stages << Operator::Match.new(&block)
      end

      def group(&block)
        @stages << Operator::Group.new(&block)
      end

      def add_fields(&block)
        @stages << Operator::AddFields.new(&block)
      end

      def bucket(&block)
        @stages << Operator::Bucket.new(&block)
      end

      def lookup(&block)
        @stages << Operator::Lookup.new(&block)
      end

      def replace_root(&block)
        @stages << Operator::ReplaceRoot.new(&block)
      end

      def project(&block)
        @stages << Operator::Project.new(&block)
      end

      def replace_root(&block)
        @stages << Operator::ReplaceRoot.new(&block)
      end

      def project(&block)
        @stages << Operator::Project.new(&block)
      end

      def replace_root(&block)
        @stages << Operator::ReplaceRoot.new(&block)
      end

      def project(&block)
        @stages << Operator::Project.new(&block)
      end

      def set(&block)
        @stages << Operator::Set.new(&block)
      end
    end
  end
end

