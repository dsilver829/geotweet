require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  before(:each) do
    Geotweet.create(status: "Geotweet #1 Foo", latitude: 37.78, longitude: -122.39)
    Geotweet.create(status: "Geotweet #2 Bar", latitude: 37.78, longitude: -122.41)
    Geotweet.create(status: "Geotweet #3 Bash", latitude: -37.78, longitude: 122.41)
    Geotweet.create(status: "Geotweet #4 Baz", latitude: 37.77, longitude: -122.39)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
  end

  scenario 'updates the tweets', js: true do
    visit root_path
    fill_in 'query-input', with: 'bar'
    click_on 'Search'

    expect(page).to have_text "2"
    expect(page).to_not have_text "3"
  end
end