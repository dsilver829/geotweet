module GeotweetsHelper
  def markers(geotweets)
    markers = []
    geotweets.each_with_index do |geotweet, index|
      markers << "markers=color:red%7Clabel:#{index+1}%7C" + URI.encode(geotweet.place.full_name)
    end
    return markers
  end
end
