require 'spec_helper'

module Lookup2
  class Order
    include Mongoid::Document

    field :item, type: String
    field :price, type: Integer
    field :quantity, type: Integer
  end

  class Item
    include Mongoid::Document

    store_in collection: 'inventory'

    field :item, type: String
    field :description, type: String
    field :instock, type: Integer
  end

  class Result
    include Mongoid::Aggregation::Result

    field :_id, type: Integer
    field :item, type: String
    field :price, type: Integer
    field :quantity, type: Integer
  end
end

describe '$lookup' do
  before do
    Lookup2::Order.collection.drop
    Lookup2::Order.create!(_id: 1, item: 'almonds', price: 12, quantity: 2)
    Lookup2::Order.create!(_id: 2, item: 'pecans', price: 20, quantity: 1)
    Lookup2::Item.collection.drop
    Lookup2::Item.create!(_id: 1, item: 'almonds', description: 'almond clusters', instock: 120)
    Lookup2::Item.create!(_id: 2, item: 'bread', description: 'raisin and nut bread', instock: 80)
    Lookup2::Item.create!(_id: 3, item: 'pecans', description: 'candied pecans', instock: 60)
  end

  it 'aggregates' do
    results = Lookup2::Order.aggregate(Lookup2::Result) do
      lookup do
        from(:items)
        local_field(:item)
        foreign_field(:item)
        as(:from_items)
      end
      replace_root do
        merge_objects(
          array_elem_at(field(:from_items), 0),
          '$$ROOT'
        )
      end
      project do
        from_items(0)
      end
    end.to_a

    expect(results.count).to eq(2)
  end
end

