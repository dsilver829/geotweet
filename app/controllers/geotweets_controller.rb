require 'geocoder/results/freegeoip'

class GeotweetsController < ApplicationController
  def index
    # @location = request.location
    # @corners = [@location.longitude-0.5,@location.latitude-0.5,@location.longitude+0.5,@location.latitude+0.5]
    # TweetStream::Client.new.locations(@corners.join(",")) do |geotweet, client|
    #   coordinates = geotweet.place.bounding_box.coordinates[0]
    #   (longitude, latitude) = coordinates.transpose.map{|e| e.inject(:+)}.map{|e| e / coordinates.size}
    #   puts geotweet.text
    #   @geotweets << geotweet
    #   client.stop if @geotweets.size >= 10
    # end
    # puts "STOP!"

    respond_to do |format|
      format.html { @location  = request.location || Geocoder::Result::Freegeoip.new("latitude" => 37.7898, "longitude" => -122.3942)  }
      format.js   { @geotweets = Geotweet.geosearch(top_left: top_left, bottom_right: bottom_right, limit: limit, query: query) }
    end
  end

  private

  def top_left
    { lat: params[:lat1], lon: params[:lon0] }
  end

  def bottom_right
    { lat: params[:lat0], lon: params[:lon1] }
  end

  def limit
    params[:limit] || Geotweet::LIMIT
  end

  def query
    params[:query]
  end
end
