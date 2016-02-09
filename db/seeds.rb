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
    Tweet.create(status: "Tweet ##{i}", latitude: latitude, longitude: longitude)
    i += 1
  end
end