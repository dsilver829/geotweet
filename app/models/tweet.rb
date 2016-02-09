require 'elasticsearch/model'
require 'jbuilder'

class Tweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name [Rails.application.engine_name.gsub(/_application/,''), Rails.env, self.base_class.to_s.pluralize.underscore].join('_')

  mapping do
    indexes :id, type: "integer"
    indexes :location, type: "geo_point", geohash_prefix: true
    indexes :status
  end

  def as_indexed_json(_options = {})
    as_json methods: [:location]
  end

  def location
    { lat: latitude.to_f, lon: longitude.to_f }
  end

  def self.geosearch(location)
    query = geoquery(location)
    self.search(query)
  end

  private

  def self.geoquery(location)
    Jbuilder.encode do |json|
      json.query do
        json.filtered do
          json.filter do
            json.geohash_cell do
              json.location do
                json.lat location.latitude
                json.lon location.longitude
              end
              json.neighbors true
              json.precision "2km"
            end
          end
        end
      end
    end
  end
end
