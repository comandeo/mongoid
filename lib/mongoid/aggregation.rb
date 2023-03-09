module Mongoid
  module Aggregation
    extend ActiveSupport::Concern

    module ClassMethods
      def aggregate(result_class, &block)
        builder = Builder.new(self, result_class)
        builder.instance_eval(&block)
        command = builder.build
pp command
        collection.aggregate(command).map do |doc|
          Factory.from_db(result_class, doc)
        end
      end
    end
  end
end
