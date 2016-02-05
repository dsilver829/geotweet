module ApplicationHelper
  def statuses
    @statuses = []
    i = 0
    TweetStream::Client.new.sample do |status, client|
      i += 1
      puts status.text
      @statuses << status.text
      client.stop if i >= 10
    end
    puts "STOP!"
    return @statuses
  end
end
