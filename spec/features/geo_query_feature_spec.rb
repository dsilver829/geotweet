require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  before(:each) do
    Geotweet.create(status: "Geotweet #1", latitude: 37.78, longitude: -122.39)
    Geotweet.create(status: "Geotweet #2", latitude: 37.78, longitude: -122.41)
    Geotweet.create(status: "Geotweet #3", latitude: -37.78, longitude: 122.41)
    Geotweet.create(status: "Geotweet #4", latitude: 37.77, longitude: -122.39)
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
  end

  scenario 'finds the tweets', js: true do
    visit root_path
    expect(page).to have_text "Geotweet #1"
    expect(page).to have_text "Geotweet #2"
    expect(page).to_not have_text "Geotweet #3"
    expect(page).to have_text "Geotweet #4"
  end

  scenario 'shows the tweets only once', js: true do
    visit root_path
    fill_in 'pac-input', with: 'north america'
    page.execute_script("$('#pac-input').trigger($.Event('keydown', {keyCode: 13}))")

    expect(page).to have_text "Geotweet #1", count: 1
    expect(page).to have_text "Geotweet #2", count: 1
    expect(page).to_not have_text "Geotweet #3"
    expect(page).to have_text "Geotweet #4", count: 1
  end

  scenario 'shows the tweets in descending chronological order', js: true do
    visit root_path
    items = page.all('ol#geotweet-list li')
    expect(items.first.text).to include 'Geotweet #4'
    expect(items.last.text).to include 'Geotweet #1'
  end

  scenario 'limit the tweets to 250 at a time', js: true do
    (1..260).each do |i|
      Geotweet.create(status: "MyGeotweet ##{i}-Test", latitude: 37.78, longitude: -122.39)
    end
    Geotweet.import
    Geotweet.__elasticsearch__.refresh_index!
    visit root_path
    expect(page).to have_text "MyGeotweet #260-Test", count: 1
    expect(page).to have_text "MyGeotweet #11-Test", count: 1
    expect(page).to_not have_text "MyGeotweet #1-Test", count: 1
  end
end