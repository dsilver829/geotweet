Geotweet.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']
Geotweet.__elasticsearch__.create_index! force: true
Geotweet.__elasticsearch__.refresh_index!