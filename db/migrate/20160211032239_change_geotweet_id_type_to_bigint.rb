class ChangeGeotweetIdTypeToBigint < ActiveRecord::Migration
  def up
    execute "ALTER TABLE geotweets ALTER COLUMN id SET DATA TYPE bigint"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
