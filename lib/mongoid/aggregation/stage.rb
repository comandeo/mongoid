# frozen_string_literal: true

require "mongoid/aggregation/expressions"

module Mongoid
  module Aggregation
    class Stage
      include Expressions

      def compile
        raise NotImplementedError
      end
    end
  end
end

require "mongoid/aggregation/stage/add_fields"
require "mongoid/aggregation/stage/bucket"
require "mongoid/aggregation/stage/group"
require "mongoid/aggregation/stage/match"
