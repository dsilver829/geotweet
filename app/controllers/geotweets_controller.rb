class GeotweetsController < ApplicationController
  def index
    @geotweets = []
    TweetStream::Client.new.sample do |status, client|
      puts status.text
      @geotweets << status.text
      client.stop if @geotweets.size >= 10
    end
    puts "STOP!"
  end
end
