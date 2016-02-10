require 'geocoder/results/freegeoip'

class GeotweetsController < ApplicationController
  def index
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
