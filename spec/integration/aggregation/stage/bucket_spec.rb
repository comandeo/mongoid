require 'spec_helper'

module Bucket
  class Artist
    include Mongoid::Document
    field :last_name, type: String
    field :first_name, type: String
    field :year_born, type: Integer
    field :year_died, type: Integer
    field :nationality, type: String
  end

  class Result
    class Artist
      include Mongoid::Aggregation::Result

      field :name, type: String
      field :year_born, type: Integer
    end

    include Mongoid::Aggregation::Result

    field :_id, type: String
    field :count, type: Integer
    embeds_many :artists, class_name: 'Bucket::Result::Artist'
  end
end

describe '$bucket' do

  before do
    Bucket::Artist.collection.drop
    Bucket::Artist.create!("_id" => 1, "last_name" => "Bernard", "first_name" => "Emil", "year_born" => 1868, "year_died" => 1941, "nationality" => "France")
    Bucket::Artist.create!("_id" => 2, "last_name" => "Rippl-Ronai", "first_name" => "Joszef", "year_born" => 1861, "year_died" => 1927, "nationality" => "Hungary")
    Bucket::Artist.create!("_id" => 3, "last_name" => "Ostroumova", "first_name" => "Anna", "year_born" => 1871, "year_died" => 1955, "nationality" => "Russia")
    Bucket::Artist.create!("_id" => 4, "last_name" => "Van Gogh", "first_name" => "Vincent", "year_born" => 1853, "year_died" => 1890, "nationality" => "Holland")
    Bucket::Artist.create!("_id" => 5, "last_name" => "Maurer", "first_name" => "Alfred", "year_born" => 1868, "year_died" => 1932, "nationality" => "USA")
    Bucket::Artist.create!("_id" => 6, "last_name" => "Munch", "first_name" => "Edvard", "year_born" => 1863, "year_died" => 1944, "nationality" => "Norway")
    Bucket::Artist.create!("_id" => 7, "last_name" => "Redon", "first_name" => "Odilon", "year_born" => 1840, "year_died" => 1916, "nationality" => "France")
    Bucket::Artist.create!("_id" => 8, "last_name" => "Diriks", "first_name" => "Edvard", "year_born" => 1855, "year_died" => 1930, "nationality" => "Norway")
  end

  it 'aggregates' do
    results = Bucket::Artist.aggregate(Bucket::Result) do
      bucket do
        group_by field(:year_born)
        boundaries [1840, 1850, 1860, 1870, 1880]
        default "Other"
        output do
          count { sum(1) }
          artists do
            push do
              name { concat(field(:first_name), " ", field(:last_name)) }
              year_born field(:year_born)
            end
          end
        end
      end
      match do
        Mongoid::Criteria.new(Bucket::Result).where(:count.gt => 3)
      end
    end.to_a

    expect(results.count).to eq(1)
    expect(results.first._id).to eq("1860")
    expect(results.first.count).to eq(4)
    expect(results.first.artists.count).to eq(4)
    expect(results.first.artists.first.name).to eq("Emil Bernard")
    expect(results.first.artists.first.year_born).to eq(1868)
    expect(results.first.artists.second.name).to eq("Joszef Rippl-Ronai")
    expect(results.first.artists.second.year_born).to eq(1861)
    expect(results.first.artists.third.name).to eq("Alfred Maurer")
    expect(results.first.artists.third.year_born).to eq(1868)
    expect(results.first.artists.fourth.name).to eq("Edvard Munch")
    expect(results.first.artists.fourth.year_born).to eq(1863)
  end
end
