require 'rails_helper'
require 'spec_helper'

describe Geotweet, type: :model do
  let(:tweet) { Geotweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0) }

  it "saves" do
    expect(tweet).to be_persisted
  end

  it 'supports elasticsearch' do
    Geotweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
    response = Geotweet.search("Hello")
    expect(response.results.total).to eq 1
  end

  it 'accepts search queries' do
    Geotweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Geotweet.create(status: "Good bye!", longitude: 1.0, latitude: 1.0)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
    response = Geotweet.search("*:*")
    expect(response.results.total).to eq 2
    response = Geotweet.search("hello")
    expect(response.results.total).to eq 1
  end

  it "supports geosearch" do
    Geotweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Geotweet.create(status: "Good bye!", longitude: 90.0, latitude: 90.0)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
    response = Geotweet.geosearch(top_left: {lat: 2.0, lon: 0.0 }, bottom_right: {lat: 0.0, lon: 2.0 })
    expect(response.results.total).to eq 1
  end
end
