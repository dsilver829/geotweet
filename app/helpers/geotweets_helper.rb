module GeotweetsHelper
  def markers(geotweets)
    markers = []
    geotweets.each_with_index do |geotweet, index|
      markers << "markers=color:red%7Clabel:#{index+1}%7C" + URI.encode(geotweet.place.full_name)
    end
    return markers
  end

  def time_diff(geotweet)
    creation = geotweet.created_at.to_time
    diff = (Time.now - creation).to_i
    date_str(creation, diff) || diff_str(diff) || "Now"
  end

  private

  def date_str(creation, diff)
    if diff < 60 * 60 * 24
      return nil
    end
    creation.strftime("%e %b")
  end

  def diff_str(diff)
    hours_diff(diff) || minutes_diff(diff)
  end

  def hours_diff(diff)
    hours = diff / (60 * 60)
    if hours > 0
      "#{hours}h"
    end
  end

  def minutes_diff(diff)
    minutes = diff / 60
    if minutes > 0
      "#{minutes}m"
    end
  end

  def seconds_diff(diff)
    "#{diff}s"
  end
end
