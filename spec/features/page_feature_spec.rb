require 'rails_helper'
require 'spec_helper'

feature 'Page' do
  before(:each) do
    Tweet.create(status: "Tweet #1", latitude: 37.78, longitude: -122.39)
    Tweet.create(status: "Tweet #2", latitude: 37.78, longitude: -122.41)
    Tweet.create(status: "Tweet #3", latitude: -37.78, longitude: 122.41)
    Tweet.create(status: "Tweet #4", latitude: 37.77, longitude: -122.39)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
  end

  scenario 'displays the webapp name' do
    visit root_url
    expect(page).to have_text "Geotweet"
  end

  scenario 'shows the tweets', js: true do
    visit root_path
    expect(page).to have_text "Tweet #1"
    expect(page).to have_text "Tweet #2"
    expect(page).to_not have_text "Tweet #3"
    expect(page).to have_text "Tweet #4"
  end

  scenario 'shows the tweets only once', js: true do
    visit root_path
    fill_in 'pac-input', with: 'north america'
    page.execute_script("$('#pac-input').trigger($.Event('keydown', {keyCode: 13}))")

    expect(page).to have_text "Tweet #1", count: 1
    expect(page).to have_text "Tweet #2", count: 1
    expect(page).to_not have_text "Tweet #3"
    expect(page).to have_text "Tweet #4", count: 1
  end

  scenario 'shows the tweets in descending chronological order', js: true do
    visit root_path
    items = page.all('ol#geotweet-list li')
    expect(items.first.text).to eq 'Tweet #4'
    expect(items.last.text).to eq 'Tweet #1'
  end
end