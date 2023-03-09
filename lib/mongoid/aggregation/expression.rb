# frozen_string_literal: true

require 'mongoid/aggregation/expressions'
require 'mongoid/aggregation/expression/add'
require 'mongoid/aggregation/expression/avg'
require 'mongoid/aggregation/expression/concat'
require 'mongoid/aggregation/expression/date_to_string'
require 'mongoid/aggregation/expression/field_path'
require 'mongoid/aggregation/expression/literal'
require 'mongoid/aggregation/expression/multiply'
require 'mongoid/aggregation/expression/output'
require 'mongoid/aggregation/expression/push'
require 'mongoid/aggregation/expression/sum'

module Mongoid
  module Aggregation
    class Expression
      include Expressions
    end
  end
end

