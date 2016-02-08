require 'elasticsearch/model'
require 'jbuilder'

class Tweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name [Rails.application.engine_name.gsub(/_application/,''), Rails.env, self.base_class.to_s.pluralize.underscore].join('_')

  mapping do
    indexes :id, type: "integer"
    indexes :status
  end
end
