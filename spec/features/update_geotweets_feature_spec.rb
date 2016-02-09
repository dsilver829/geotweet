require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  before(:each) do
    Geotweet.create(status: "Geotweet #1-Foo", latitude: 37.78, longitude: -122.39)
    Geotweet.create(status: "Geotweet #2-Foo", latitude: 37.78, longitude: -122.41)
    Geotweet.create(status: "Geotweet #3-Foo", latitude: -37.78, longitude: 122.41)
    Geotweet.create(status: "Geotweet #4-Foo", latitude: 37.77, longitude: -122.39)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
  end

  scenario 'updates the tweets', js: true do
    visit root_path
    Geotweet.create(status: "Geotweet #5", latitude: 37.775, longitude: -122.395)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
    expect(page).to have_text "Geotweet #5"
  end

  scenario 'makes room for the most recent tweet', js: true do
    (1..250).each do |i|
      Geotweet.create(status: "MyGeotweet ##{i}-Test", latitude: 37.78, longitude: -122.39)
    end
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!

    visit root_path

    Geotweet.create(status: "Geotweet #1-Bar", latitude: 37.775, longitude: -122.395)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!

    expect(page).to have_text "Geotweet #250-Test"
    expect(page).to have_text "Geotweet #2-Test"
    expect(page).to have_text "Geotweet #1-Bar"
    expect(page).to_not have_text "Geotweet #1-Test"
  end
end