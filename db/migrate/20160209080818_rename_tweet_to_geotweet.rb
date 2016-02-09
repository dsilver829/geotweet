class RenameTweetToGeotweet < ActiveRecord::Migration
  def change
    rename_table(:tweets, :geotweets)
  end
end
