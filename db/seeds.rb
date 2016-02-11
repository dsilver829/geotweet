# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

i = 0
(-90...90).step(10) do |latitude|
  (-180...180).step(10) do |longitude|
    Geotweet.new(latitude: latitude, longitude: longitude, status: "Test ##{i}", user_name: "Tester", user_profile_image_url: "https://pbs.twimg.com/profile_images/666407537084796928/YBGgi9BO_bigger.png", user_screen_name: "test")
    i += 1
  end
end