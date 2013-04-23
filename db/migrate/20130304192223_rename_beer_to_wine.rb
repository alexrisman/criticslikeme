class RenameBeerToWine < ActiveRecord::Migration
  def up
    rename_table :beers, :wines
    rename_column :ratings, :beer_id, :wine_id
  end

  def down
    rename_table :wines, :beers
    rename_column :ratings, :wine_id, :beer_id
  end
end
