require 'rails_helper'
require 'spec_helper'

describe Geotweet, type: :model do
  it 'supports elasticsearch' do
    tweet = build(:geotweet, longitude: 1.0, latitude: 1.0)
    wait_for_indexing(1)
    response = Geotweet.__elasticsearch__.search("*:*")
    expect(response.results.total).to eq 1
  end

  it 'accepts search queries' do
    geotweets = []
    geotweets << build(:geotweet, status: "Baz", longitude: 1.0, latitude: 1.0)
    geotweets << build(:geotweet, longitude: 1.0, latitude: 1.0)

    wait_for_indexing(2)

    response = Geotweet.geosearch(top_left: {lat: 90.0, lon: -180.0 }, bottom_right: {lat: -90.0, lon: 180.0 })
    expect(response.results.total).to eq 2
    response = Geotweet.geosearch(top_left: {lat: 90.0, lon: -180.0 }, bottom_right: {lat: -90.0, lon: 180.0 }, query: geotweets[0].status)
    expect(response.results.total).to eq 1
  end

  it "supports geosearch" do
    build(:geotweet, longitude: 1.0, latitude: 1.0)
    build(:geotweet, longitude: 90.0, latitude: 90.0)
    wait_for_indexing(2)
    response = Geotweet.geosearch(top_left: {lat: 2.0, lon: 0.0 }, bottom_right: {lat: 0.0, lon: 2.0 })
    expect(response.results.total).to eq 1
  end

  it "supports geohash" do
    geotweet1 = build(:geotweet, longitude: 1.0, latitude: 1.0)
    build(:geotweet, longitude: 1.0, latitude: 1.0)
    build(:geotweet, longitude: 90.0, latitude: 90.0)
    wait_for_indexing(3)
    results = geotweet1.geohash_neighbors
    expect(results.total).to eq 2
  end
end

# private

def wait_for_indexing(n)
  total = 0
  Timeout::timeout(5) do
    while(total != n)
      total = Geotweet.search("*:*").results.total
    end
  end
end
