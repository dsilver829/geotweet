require 'rails_helper'
require 'spec_helper'

feature 'Geo-Query' do
  # before(:each) do
  #   create(:geotweet, status: "Geotweet #1", latitude: 37.78, longitude: -122.39, created_at: Time.now - 1.year + 1)
  #   create(:geotweet, status: "Geotweet #2", latitude: 37.78, longitude: -122.41, created_at: Time.now - 1.year + 1)
  #   create(:geotweet, status: "Geotweet #3", latitude: -37.78, longitude: 122.41, created_at: Time.now - 1.year + 1)
  #   create(:geotweet, status: "Geotweet #4", latitude: 37.77, longitude: -122.39, created_at: Time.now - 1.year + 1)
  #   Geotweet.import
  #   Geotweet.__elasticsearch__.refresh_index!
  # end
  #
  # scenario 'finds the tweets', js: true do
  #   visit root_path
  #   expect(page).to have_text "Geotweet #1"
  #   expect(page).to have_text "Geotweet #2"
  #   expect(page).to_not have_text "Geotweet #3"
  #   expect(page).to have_text "Geotweet #4"
  # end
  #
  # scenario 'shows the tweets only once', js: true do
  #   visit root_path
  #   fill_in 'pac-input', with: 'north america'
  #   page.execute_script("$('#pac-input').trigger($.Event('keydown', {keyCode: 13}))")
  #
  #   expect(page).to have_text "Geotweet #1", count: 1
  #   expect(page).to have_text "Geotweet #2", count: 1
  #   expect(page).to_not have_text "Geotweet #3"
  #   expect(page).to have_text "Geotweet #4", count: 1
  # end
  #
  # scenario 'shows the tweets in descending chronological order', js: true do
  #   visit root_path
  #   items = page.all('ol#geotweet-list li')
  #   expect(items.first.text).to include 'Geotweet #4'
  #   expect(items.last.text).to include 'Geotweet #1'
  # end

  scenario 'limit the tweets to 250 at a time', js: true, focus: true do
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