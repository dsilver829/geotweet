require 'rails_helper'
require 'spec_helper'

describe "geotweet" do
  let(:geotweet) { Geotweet.create id: 1, status: "Welcome to Twitter!", latitude: 0, longitude: 0 }

  it "saves" do
    expect(geotweet).to be_persisted
  end

  it "has latitude and longitude fields" do
    expect(geotweet.latitude).to be_present
    expect(geotweet.longitude).to be_present
  end
end