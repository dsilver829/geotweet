require 'rails_helper'
require 'spec_helper'

describe "geotweet" do
  it "saves" do
    article = Geotweet.create id: 1
    expect(article).to be_persisted
  end
end