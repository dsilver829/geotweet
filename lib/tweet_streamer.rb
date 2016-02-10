puts ENV["RAILS_ENV"]

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, 'config', 'environment')

log = File.join(root, 'log', 'stream.log')

daemon = TweetStream::Daemon.new('tweet_streamer', log_output: true)
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
  ActiveRecord::Base.logger = Logger.new(File.open(log, 'w+'))
end
ActiveRecord::Base.logger.info("starting...")
daemon.locations(-180,-90,180,90) do |tweet|
  puts "tweet"
  ActiveRecord::Base.logger.info(tweet.full_text)
  coordinates = tweet.place.bounding_box.coordinates[0]
  (longitude, latitude) = coordinates.transpose.map{|e| e.inject(:+)}.map{|e| e / coordinates.size}
  puts "create"
  geotweet = ::Geotweet.create(created_at: tweet.created_at, latitude: latitude, longitude: longitude, status: tweet.full_text, user_name: tweet.user.name, user_profile_image_url: tweet.user.profile_image_url, user_screen_name: tweet.user.screen_name)
  if(geotweet.persisted?)
    puts "persisted"
  else
    puts "not persisted"
  end
  geotweet.__elastic__search.index_document
  neighbors = geotweet.geohash_neighbors
  puts "neighbors.total: " + neighbors.total
  if(neighbors.total > Geotweet::LIMIT)
    puts "DELETE"
    neighbor = neighbors.to_a.first
    neighbor = Geotweet.find(neighbor.id)
    neighbor.__elasticsearch__.delete_document
    ActiveRecord::Base.logger.info(tweet.full_text)
    Geotweet.destroy(neighbor.id)
  end
end