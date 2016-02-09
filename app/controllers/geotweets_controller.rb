require 'geocoder/results/freegeoip'

class GeotweetsController < ApplicationController
  def index
    respond_to do |format|
      format.html { @location  = request.location || Geocoder::Result::Freegeoip.new("latitude" => 37.7898, "longitude" => -122.3942)  }
      format.js   { @geotweets = Tweet.geosearch( top_left: { lat: params[:lat1], lon: params[:lon0] }, bottom_right: { lat: params[:lat0], lon: params[:lon1] }) }
    end

    #@corners = [@location.longitude-0.3,@location.latitude-0.3,@location.longitude+0.3,@location.latitude+0.3]
    #@geotweets = Tweet.geosearch(@location)
    # @geotweets = []
    # TweetStream::Client.new.locations(@corners.join(",")) do |geotweet, client|
    #   puts geotweet.text
    #   @geotweets << geotweet
    #   client.stop if @geotweets.size >= 10
    # end
    # puts "STOP!"
  end
end
