require 'rails_helper'
require 'spec_helper'

describe Tweet, type: :model do
  let(:tweet) { Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0) }

  it "saves" do
    expect(tweet).to be_persisted
  end

  it 'supports elasticsearch' do
    Tweet.create(status: "Hello!", longitude: 1.0, latitude: 1.0)
    Tweet.import
    Tweet.__elasticsearch__.refresh_index!
    response = Tweet.search("Hello")
    expect(response.results.total).to eq 1
  end
end
