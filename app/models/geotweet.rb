class Geotweet
  include Elasticsearch::Persistence::Model

  attribute :status, String
  validates :status, presence: true

  attribute :latitude, Float
  validates :latitude, presence: true

  attribute :longitude, Float
  validates :longitude, presence: true

  mapping do
    indexes :location, type: 'geo_point'
  end

  def as_indexed_json
    as_json(location: {lat: lat, lon: lon})
  end

  # Execute code after saving the model.
  #
  after_save { puts "Successfully saved: #{self}" }
end