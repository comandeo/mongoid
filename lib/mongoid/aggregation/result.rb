# frozen_string_literal: true

require 'mongoid/document'

module Mongoid
  module Aggregation
    module Result
      extend ActiveSupport::Concern
      include Mongoid::Document
    end
  end
end

require 'mongoid/aggregation/builder'
require 'mongoid/aggregation/result'
require 'mongoid/aggregation/operator'
require 'mongoid/aggregation/operators'
