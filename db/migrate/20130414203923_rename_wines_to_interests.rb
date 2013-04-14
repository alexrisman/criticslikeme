class RenameWinesToInterests < ActiveRecord::Migration
  def up
    rename_table :wines, :interests
    rename_column :ratings, :wine_id, :interest_id
  end

  def down
    rename_table :interests, :wines
    rename_column :ratings, :interest_id, :wine_id
  end

end
