require 'spec_helper'

module SetStage
  class Score
    include Mongoid::Document

    field :student, type: String
    field :homework, type: Array
    field :quiz, type: Array
    field :extra_credit, type: Integer
  end

  class Result
    include Mongoid::Aggregation::Result

    field :_id, type: Integer
    field :student, type: String
    field :homework, type: Array
    field :quiz, type: Array
    field :extra_credit, type: Integer
    field :total_homework, type: Integer
    field :total_quiz, type: Integer
    field :total_score, type: Integer
  end
end

describe '$set' do
  before do
    SetStage::Score.collection.drop
    SetStage::Score.create!(_id: 1, student: 'Maya', homework: [10, 5, 10], quiz: [10, 8], extra_credit: 0)
    SetStage::Score.create!(_id: 2, student: 'Ryan', homework: [5, 6, 5], quiz: [8, 8], extra_credit: 8)
  end

  it 'aggregates' do
    results = SetStage::Score.aggregate(SetStage::Result) do
      set do
        total_homework do
          sum do
            field(:homework)
          end
        end
        total_quiz do
          sum do
            field(:quiz)
          end
        end
      end
      set do
        total_score do
          add(
            field(:total_homework),
            field(:total_quiz),
            field(:extra_credit)
          )
        end
      end
    end.to_a

    expect(results.count).to eq(2)
    results.find { |el| el._id == 1 }.tap do |result|
      expect(result.total_homework).to eq(25)
      expect(result.total_quiz).to eq(18)
      expect(result.total_score).to eq(43)
    end
    results.find { |el| el._id == 2 }.tap do |result|
      expect(result.total_homework).to eq(16)
      expect(result.total_quiz).to eq(16)
      expect(result.total_score).to eq(40)
    end
  end
end
