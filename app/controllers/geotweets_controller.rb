class GeotweetsController < ApplicationController
  def index
    @location = request.location
    @geotweets = []
    locations = [@location.longitude-1,@location.latitude-1,@location.longitude+1,@location.latitude+1]
    TweetStream::Client.new.locations(locations.join(",")) do |status, client|
      puts status.text
      @geotweets << status.text
      client.stop if @geotweets.size >= 10
    end
    puts "STOP!"
  end
end
