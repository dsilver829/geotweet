class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :status
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
