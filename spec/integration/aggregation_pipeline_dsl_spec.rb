require 'spec_helper'

class Order
  include Mongoid::Document

  field :name, type: String
  field :size, type: String
  field :price, type: Integer
  field :quantity, type: Integer
  field :date, type: DateTime
end


describe 'Aggregation Pipeline DSL' do
  before do
    Order.collection.drop
    Order.create!(_id: 0, name: "Pepperoni", size: "small", price: 19,
      quantity: 10, date: DateTime.parse( "2021-03-13T08:14:30Z" ))
    Order.create!(_id: 1, name: "Pepperoni", size: "medium", price: 20,
      quantity: 20, date: DateTime.parse( "2021-03-13T09:13:24Z" ))
    Order.create!(_id: 2, name: "Pepperoni", size: "large", price: 21,
      quantity: 30, date: DateTime.parse( "2021-03-17T09:22:12Z" ))
    Order.create!(_id: 3, name: "Cheese", size: "small", price: 12,
      quantity: 15, date: DateTime.parse( "2021-03-13T11:21:39.736Z" ))
    Order.create!(_id: 4, name: "Cheese", size: "medium", price: 13,
      quantity:50, date: DateTime.parse( "2022-01-12T21:23:13.331Z" ))
    Order.create!(_id: 5, name: "Cheese", size: "large", price: 14,
      quantity: 10, date: DateTime.parse( "2022-01-12T05:08:13Z" ))
    Order.create!(_id: 6, name: "Vegan", size: "small", price: 17,
      quantity: 10, date: DateTime.parse( "2021-01-13T05:08:13Z" ))
    Order.create!(_id: 7, name: "Vegan", size: "medium", price: 18,
      quantity: 10, date: DateTime.parse( "2021-01-13T05:10:13Z" ))
  end

  it 'calculates total order quantity' do
    class TOQResult1
      include Mongoid::Aggregation::Result

      field :_id, type: String
      field :total_quantity, type: Integer
    end

    results = Order.aggregate(TOQResult1) do
      match { where(size: 'medium') }
      group do
        _id field(:name)
        total_quantity { sum(field(:quantity)) }
      end
    end.to_a


    expect(results.count).to eq(3)
    expect(results.find { |el| el._id == 'Cheese'    }.total_quantity).to eq(50)
    expect(results.find { |el| el._id == 'Vegan'     }.total_quantity).to eq(10)
    expect(results.find { |el| el._id == 'Pepperoni' }.total_quantity).to eq(20)
  end

  it 'Calculate Total Order Value and Average Order Quantity' do
    class TOQResult2
      include Mongoid::Aggregation::Result

      field :_id, type: Date
      field :total_order_value, type: Integer
      field :average_order_quantity, type: Float
    end

    results = Order.aggregate(TOQResult2) do
      match do
        where(
          date: { '$gte' => Date.parse('2020-01-30'), '$lt' => Date.parse('2022-01-30') }
        )
      end
      group do
        _id  { date_to_string(format: "%Y-%m-%d", date: field(:date) ) }
        total_order_value { sum { multiply(field(:price), field(:quantity)) } }
        average_order_quantity { avg(field(:quantity)) }
      end
    end.to_a

    expect(results.count).to eq(4)
    results.find { |el| el._id == Date.parse('2022-01-12') }.tap do |result|
      expect(result.total_order_value).to eq(790)
      expect(result.average_order_quantity).to eq(30)
    end
    results.find { |el| el._id == Date.parse('2021-03-13') }.tap do |result|
      expect(result.total_order_value).to eq(770)
      expect(result.average_order_quantity).to eq(15)
    end
    results.find { |el| el._id == Date.parse('2021-03-17') }.tap do |result|
      expect(result.total_order_value).to eq(630)
      expect(result.average_order_quantity).to eq(30)
    end
    results.find { |el| el._id == Date.parse('2021-01-13') }.tap do |result|
      expect(result.total_order_value).to eq(350)
      expect(result.average_order_quantity).to eq(10)
    end
  end
end
