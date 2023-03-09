require 'spec_helper'

module Lookup1
  class Order
    include Mongoid::Document

    field :item, type: String
    field :price, type: Integer
    field :quantity, type: Integer
  end

  class Inventory
    include Mongoid::Document

    store_in collection: 'inventory'

    field :sku, type: String
    field :description, type: String
    field :instock, type: Integer
  end

  class Result
    include Mongoid::Aggregation::Result

    field :_id, type: Integer
    field :item, type: String
    field :price, type: Integer
    field :quantity, type: Integer

    embeds_many :inventory_docs, class_name: 'Lookup1::Inventory', store_as: 'inventory_docs'
  end
end

describe '$lookup' do
  before do
    Lookup1::Order.collection.drop
    Lookup1::Order.create!(_id: 1, item: 'almonds', price: 12, quantity: 2)
    Lookup1::Order.create!(_id: 2, item: 'pecans', price: 20, quantity: 1)
    Lookup1::Order.create!(_id: 3)
    Lookup1::Inventory.collection.drop
    Lookup1::Inventory.create!(_id: 1, sku: 'almonds', description: 'product 1', instock: 120)
    Lookup1::Inventory.create!(_id: 2, sku: 'bread', description: 'product 2', instock: 80)
    Lookup1::Inventory.create!(_id: 3, sku: 'cashews', description: 'product 3', instock: 60)
    Lookup1::Inventory.create!(_id: 4, sku: 'pecans', description: 'product 4', instock: 70)
    Lookup1::Inventory.create!(_id: 5, sku: nil, description: 'Incomplete')
    Lookup1::Inventory.create!(_id: 6)
  end

  it 'aggregates' do
    results = Lookup1::Order.aggregate(Lookup1::Result) do
      lookup do
        from(:inventory)
        local_field(:item)
        foreign_field(:sku)
        as(:inventory_docs)
      end
    end.to_a

    expect(results.count).to eq(3)
    results.find { |el| el._id == 1 }.tap do |result|
      expect(result.item).to eq('almonds')
      expect(result.price).to eq(12)
      expect(result.quantity).to eq(2)
      expect(result.inventory_docs.count).to eq(1)
      expect(result.inventory_docs.first.sku).to eq('almonds')
      expect(result.inventory_docs.first.description).to eq('product 1')
      expect(result.inventory_docs.first.instock).to eq(120)
    end

  end
end

