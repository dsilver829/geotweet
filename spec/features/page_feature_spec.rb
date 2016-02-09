require 'rails_helper'
require 'spec_helper'

feature 'Page' do
  scenario 'displays the webapp name' do
    visit root_url
    expect(page).to have_text "Geotweet"
  end
end