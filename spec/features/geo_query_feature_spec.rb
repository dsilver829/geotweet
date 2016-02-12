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

  scenario 'finds the tweets', js: true do
    visit root_path
    expect(page).to have_text geotweets[0].status
    expect(page).to have_text geotweets[1].status
    expect(page).to_not have_text geotweets[2].status
    expect(page).to have_text geotweets[3].status
  end

  scenario 'shows the tweets only once', js: true do
    visit root_path
    fill_in 'pac-input', with: 'north america'
    page.execute_script("$('#pac-input').trigger($.Event('keydown', {keyCode: 13}))")

    expect(page).to have_text geotweets[0].status, count: 1
    expect(page).to have_text geotweets[1].status, count: 1
    expect(page).to_not have_text geotweets[2].status
    expect(page).to have_text geotweets[3].status, count: 1
  end

  scenario 'shows the tweets in descending chronological order', js: true do
    visit root_path
    expect(page).to have_text geotweets[3].status, count: 1
    items = page.all('ol#geotweet-list li')
    expect(items.first.text).to include geotweets[3].status
    expect(items.last.text).to include geotweets[0].status
  end

  scenario 'limit the tweets to 250 at a time', js: true do
    geotweets = []
    (1..260).each do |i|
      geotweets << build(:geotweet, latitude: 37.78, longitude: -122.39)
    end

    visit root_path

    expect(page).to have_text geotweets[259].status, count: 1
    expect(page).to have_text geotweets[10].status, count: 1
    expect(page).to_not have_text geotweets[0].status, count: 1
  end
end