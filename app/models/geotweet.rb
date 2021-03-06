require 'elasticsearch/model'
require 'jbuilder'

class Geotweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  LIMIT = 250

  index_name [Rails.application.engine_name.gsub(/_application/,''), Rails.env, self.base_class.to_s.pluralize.underscore].join('_')

  mapping do
    indexes :created_at, type: "date"
    indexes :id, type: "long"
    indexes :location, type: "geo_point", geohash_prefix: true, lat_lon: true
    indexes :status
    indexes :user_name
    indexes :user_profile_image_url
    indexes :user_screen_name
  end

  def as_indexed_json(_options = {})
    as_json methods: [:location]
  end

  def location
    { lat: latitude.to_f, lon: longitude.to_f }
  end

  def geohash_neighbors
    response = Geotweet.search(geohash_query)
    response.results
  end

  def self.geosearch(params)
    query = geoquery(params)
    self.search(query)
  end

  private

  def geohash_query
    Jbuilder.encode do |json|
      json.query do
        json.filtered do
          json.filter do
            json.geohash_cell do
              json.location do
                json.lat latitude
                json.lon longitude
              end
              json.precision 3
            end
          end
        end
      end
    end
  end

  def self.geoquery(params)
    Jbuilder.encode do |json|
      json.size params[:limit] || Geotweet::LIMIT
      json.query do
        json.filtered do
          if params[:query].present?
            json.query do
              json.multi_match do
                json.query params[:query]
                json.fields do
                  json.array! ["status", "user_name", "user_screen_name"]
                end
              end
            end
          end
          json.filter do
            json.geo_bounding_box do
              json.location do
                json.top_left do
                  json.lat params[:top_left][:lat] || 90
                  json.lon params[:top_left][:lon] || -180
                end
                json.bottom_right do
                  json.lat params[:bottom_right][:lat] || -90
                  json.lon params[:bottom_right][:lon] || 180
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
