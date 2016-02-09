require 'elasticsearch/model'
require 'jbuilder'

class Geotweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  LIMIT = 250

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

  def self.geosearch(params)
    query = geoquery(params)
    self.search(query)
  end

  private

  def self.geoquery(params)
    Jbuilder.encode do |json|
      json.size params[:limit] || Geotweet::LIMIT
      json.query do
        json.filtered do
          if params[:query].present?
            json.query do
              json.match do
                json.status params[:query]
              end
            end
          end
          json.filter do
            json.geo_bounding_box do
              json.location do
                json.top_left do
                  json.lat params[:top_left][:lat]
                  json.lon params[:top_left][:lon]
                end
                json.bottom_right do
                  json.lat params[:bottom_right][:lat]
                  json.lon params[:bottom_right][:lon]
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
