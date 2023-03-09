require 'spec_helper'

module AddFields
  class Score
    include Mongoid::Document

    field :student, type: String
    field :homework, type: Array
    field :quiz, type: Array
    field :extra_credit, type: Integer
  end

  class Result
    include Mongoid::Aggregation::Result

    field :_id, type: String
    field :student, type: String
    field :homework, type: Array
    field :quiz, type: Array
    field :extra_credit, type: Integer
    field :total_homework, type: Integer
    field :total_quiz, type: Integer
    field :total_score, type: Integer
  end
end

describe '$addFields' do
  before do
    AddFields::Score.collection.drop
    AddFields::Score.create!(_id: 1, student: 'Maya', homework: [10, 5, 10], quiz: [10, 8], extra_credit: 0)
    AddFields::Score.create!(_id: 2, student: 'Ryan', homework: [5, 6, 5], quiz: [8, 8], extra_credit: 8)
  end

  it 'aggregates' do
    results = AddFields::Score.aggregate(AddFields::Result) do
      add_fields do
        total_homework { sum(field(:homework)) }
        total_quiz { sum(field(:quiz)) }
      end
      add_fields do
        total_score do
          add(field(:total_homework), field(:total_quiz), field(:extra_credit))
        end
      end
    end.to_a

    expect(results.count).to eq(2)
    expect(results.find { |el| el.student == 'Maya' }.total_homework).to eq(25)
    expect(results.find { |el| el.student == 'Maya' }.total_quiz).to eq(18)
    expect(results.find { |el| el.student == 'Maya' }.total_score).to eq(43)
    expect(results.find { |el| el.student == 'Ryan' }.total_homework).to eq(16)
    expect(results.find { |el| el.student == 'Ryan' }.total_quiz).to eq(16)
    expect(results.find { |el| el.student == 'Ryan' }.total_score).to eq(40)
  end
end
