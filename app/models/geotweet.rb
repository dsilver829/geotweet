class Geotweet
  include Elasticsearch::Persistence::Model
  # Execute code after saving the model.
  #
  after_save { puts "Successfully saved: #{self}" }
end