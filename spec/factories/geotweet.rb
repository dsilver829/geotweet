FactoryGirl.define do
  factory :geotweet do
    sequence(:created_at) { |n| Time.now - 1.year + n }
    latitude    37.78
    longitude   -122.39
    sequence(:status)     { |i| "Geotweet ##{i} - Factory Default" }

    after(:build)  { |geotweet| geotweet.__elasticsearch__.index_document }
  end
end