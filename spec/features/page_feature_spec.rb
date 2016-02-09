require 'rails_helper'
require 'spec_helper'

feature 'Page' do
  scenario 'should have the webapp name' do
    visit root_url
    expect(page).to have_text "Geotweet"
  end

  scenario 'should have the webapp name', :focus do
    Tweet.create(status: "Tweet #1", latitude: 37.78, longitude: -122.39)
    Tweet.create(status: "Tweet #2", latitude: 37.78, longitude: -122.41)
    Tweet.create(status: "Tweet #3", latitude: -37.78, longitude: 122.41)
    Tweet.create(status: "Tweet #4", latitude: 37.77, longitude: -122.39)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
    visit root_url
    expect(page).to have_text "Tweet #1"
    expect(page).to have_text "Tweet #2"
    expect(page).to_not have_text "Tweet #3"
    expect(page).to have_text "Tweet #4"
  end
end