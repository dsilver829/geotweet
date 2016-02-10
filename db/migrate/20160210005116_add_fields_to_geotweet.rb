class AddFieldsToGeotweet < ActiveRecord::Migration
  def change
    add_column :geotweets, :user_name, :text
    add_column :geotweets, :user_profile_image_url, :text
    add_column :geotweets, :user_screen_name, :text
  end
end
