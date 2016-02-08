require 'rails_helper'
require 'spec_helper'

describe Tweet, type: :model do
  let(:tweet) { Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0) }

  it "saves" do
    expect(tweet).to be_persisted
  end

  it 'supports elasticsearch' do
    Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
    response = Tweet.search("Hello")
    expect(response.results.total).to eq 1
  end

  it 'accepts search queries' do
    Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Tweet.create(status: "Good bye!", longitude: 1.0, latitude: 1.0)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
    response = Tweet.search("*:*")
    expect(response.results.total).to eq 2
    response = Tweet.search("hello")
    expect(response.results.total).to eq 1
  end

  it "supports geohash" do
    Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Tweet.create(status: "Good bye!", longitude: 90.0, latitude: 90.0)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
    response = Tweet.search(geo_query)
    expect(response.results.total).to eq 1
  end

  private

  def geo_query
    Jbuilder.encode do |json|
      json.query do
        json.filtered do
          json.filter do
            json.geohash_cell do
              json.location do
                json.lat 1.0
                json.lon 1.0
              end
              json.neighbors true
              json.precision "2km"
            end
          end
        end
      end
    end
  end
end
