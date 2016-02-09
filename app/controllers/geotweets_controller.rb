class GeotweetsController < ApplicationController
  def index
    @location = request.location
    @corners = [@location.longitude-0.3,@location.latitude-0.3,@location.longitude+0.3,@location.latitude+0.3]
    @geotweets = Tweet.geosearch(@location)
    # @geotweets = []
    # TweetStream::Client.new.locations(@corners.join(",")) do |geotweet, client|
    #   puts geotweet.text
    #   @geotweets << geotweet
    #   client.stop if @geotweets.size >= 10
    # end
    # puts "STOP!"
  end
end
