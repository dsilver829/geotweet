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
end
