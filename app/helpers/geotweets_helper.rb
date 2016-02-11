module GeotweetsHelper
  def markers(geotweets)
    markers = []
    geotweets.each_with_index do |geotweet, index|
      markers << "markers=color:red%7Clabel:#{index+1}%7C" + URI.encode(geotweet.place.full_name)
    end
    return markers
  end

  def time_diff(geotweet)
    diff = (Time.now - Time.new(geotweet.created_at)).to_i
    years_diff(diff) || months_diff(diff) || days_diff(diff) || hours_diff(diff) || minutes_diff(diff) || seconds_diff(diff)
  end

  private

  def years_diff(diff)
    years = diff / (365 * 24 * 60 * 60)
    if years > 0
      "#{years}y"
    end
  end

  def months_diff(diff)
    months = diff / (30 * 24 * 60 * 60)
    if months > 0
      "#{months}mo"
    end
  end

  def days_diff(diff)
    days = diff / (24 * 60 * 60)
    if days > 0
      "#{days}d"
    end
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
      "#{minutes}min"
    end
  end

  def seconds_diff(diff)
    "#{diff}s"
  end
end
