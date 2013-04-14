class RenameBeerToInterest < ActiveRecord::Migration
  def up
    rename_table :beers, :interests
    rename_column :ratings, :beer_id, :interest_id
  end

  def down
    rename_table :interests, :beers
    rename_column :ratings, :interest_id, :beer_id
  end
end
