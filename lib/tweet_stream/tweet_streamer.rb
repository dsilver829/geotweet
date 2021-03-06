# `RAILS_ENV=production ruby ./tweet_streamer.rb start`
# In development, this must be run from the RAILS_ROOT directory, due to issues with Spring.
# In production, the Elastic Beanstalk pre- and post-deployment scripts (root/.ebextensions/) handle launching this daemon

root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
require File.join(root, 'config', 'environment')

log = File.join(root, 'lib', 'tweet_stream', 'stream.log')

daemon = TweetStream::Daemon.new('tweet_streamer', log_output: true)
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
  ActiveRecord::Base.logger = Logger.new(File.open(log, 'a'))
end
ActiveRecord::Base.logger.info("starting...")
daemon.locations(-180,-90,180,90) do |tweet|
  ActiveRecord::Base.logger.info(tweet.full_text)
  coordinates = tweet.place.bounding_box.coordinates[0]
  (longitude, latitude) = coordinates.transpose.map{|e| e.inject(:+)}.map{|e| e / coordinates.size}
  geotweet = ::Geotweet.new(created_at: tweet.created_at, id: tweet.id, latitude: latitude, longitude: longitude, status: tweet.full_text, user_name: tweet.user.name, user_profile_image_url: tweet.user.profile_image_url, user_screen_name: tweet.user.screen_name)
  geotweet.__elasticsearch__.index_document
  neighbors = geotweet.geohash_neighbors
  if(neighbors.total > Geotweet::LIMIT)
    neighbor = neighbors.to_a.last
    neighbor = ::Geotweet.new(id: neighbor.id)
    neighbor.__elasticsearch__.delete_document
    ActiveRecord::Base.logger.info(tweet.full_text)
  end
end
