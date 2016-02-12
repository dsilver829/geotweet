require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  let(:geotweets) { [] }

  before(:each) do
    geotweets << build(:geotweet, latitude: 37.78, longitude: -122.39)
    geotweets << build(:geotweet, status: "Baz", latitude: 37.78, longitude: -122.41)
    geotweets << build(:geotweet, latitude: -37.78, longitude: 122.41)
    geotweets << build(:geotweet, latitude: 37.77, longitude: -122.39)
  end

  scenario 'updates the tweets', js: true do
    visit root_path
    fill_in 'query-input', with: geotweets[1].status
    click_on 'Search'

    expect(page).to_not have_text geotweets[0].status
    expect(page).to have_text geotweets[1].status
    expect(page).to_not have_text geotweets[2].status
  end
end