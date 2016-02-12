require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  let(:geotweets) { [] }

  before(:each) do
    geotweets << build(:geotweet, latitude: 37.78, longitude: -122.39)
    geotweets << build(:geotweet, latitude: 37.78, longitude: -122.41)
    geotweets << build(:geotweet, latitude: -37.78, longitude: 122.41)
    geotweets << build(:geotweet, latitude: 37.77, longitude: -122.39)
  end

  scenario 'updates the tweets', js: true do
    visit root_path
    geotweet = build(:geotweet, latitude: 37.775, longitude: -122.395)
    expect(page).to have_text geotweet.status
  end

  scenario 'makes room for the most recent tweet', js: true do
    geotweets = []
    (1..Geotweet::LIMIT).each do |i|
      geotweets << build(:geotweet, latitude: 37.78, longitude: -122.39)
    end

    visit root_path

    new_geotweet = build(:geotweet, latitude: 37.775, longitude: -122.395)

    expect(page).to have_text geotweets.last.status
    expect(page).to have_text geotweets[1].status
    expect(page).to have_text new_geotweet.status
    expect(page).to_not have_text geotweets.first.status
  end
end