# frozen_string_literal: true

require "mongoid/aggregation/operators"

module Mongoid
  module Aggregation
    class Operator
      include Operators

      def compile
        raise NotImplementedError
      end
    end
  end
end

require 'mongoid/aggregation/operator/add'
require 'mongoid/aggregation/operator/array_elem_at'
require 'mongoid/aggregation/operator/avg'
require 'mongoid/aggregation/operator/concat'
require 'mongoid/aggregation/operator/date_to_string'
require 'mongoid/aggregation/operator/field_path'
require 'mongoid/aggregation/operator/literal'
require 'mongoid/aggregation/operator/merge_objects'
require 'mongoid/aggregation/operator/multiply'
require 'mongoid/aggregation/operator/output'
require 'mongoid/aggregation/operator/push'
require 'mongoid/aggregation/operator/sum'
require "mongoid/aggregation/operator/add_fields"
require "mongoid/aggregation/operator/bucket"
require "mongoid/aggregation/operator/group"
require "mongoid/aggregation/operator/lookup"
require "mongoid/aggregation/operator/match"
require "mongoid/aggregation/operator/project"
require "mongoid/aggregation/operator/replace_root"
require "mongoid/aggregation/operator/set"
