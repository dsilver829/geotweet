require 'elasticsearch/model'
require 'jbuilder'

class Geotweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name [Rails.application.engine_name.gsub(/_application/,''), Rails.env, self.base_class.to_s.pluralize.underscore].join('_')

  mapping do
    indexes :created_at, type: "date"
    indexes :id, type: "integer"
    indexes :location, type: "geo_point", geohash_prefix: true, lat_lon: true
    indexes :status
  end

  def as_indexed_json(_options = {})
    as_json methods: [:location]
  end

  def location
    { lat: latitude.to_f, lon: longitude.to_f }
  end

  def self.geosearch(bounds)
    puts bounds
    query = geoquery(bounds)
    self.search(query)
  end

  private

  def self.geoquery(bounds)
    Jbuilder.encode do |json|
      json.size 250
      json.query do
        json.filtered do
          json.filter do
            json.geo_bounding_box do
              json.location do
                json.top_left do
                  json.lat bounds[:top_left][:lat]
                  json.lon bounds[:top_left][:lon]
                end
                json.bottom_right do
                  json.lat bounds[:bottom_right][:lat]
                  json.lon bounds[:bottom_right][:lon]
                end
              end
            end
          end
        end
      end
      json.sort do
        json.created_at do
          json.order "desc"
        end
      end
    end
  end
end
