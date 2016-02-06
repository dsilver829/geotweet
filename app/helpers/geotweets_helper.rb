module GeotweetsHelper
  def markers(geotweets)
    markers = []
    geotweets.each do |geotweet|
      markers << URI.encode(geotweet.place.full_name)
    end
    return markers
  end
end
