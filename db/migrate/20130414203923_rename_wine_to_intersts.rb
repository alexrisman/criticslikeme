class RenameInterestToIntersts < ActiveRecord::Migration
  def up
    rename_table :interests, :interests
    rename_column :ratings, :interest_id, :interest_id
  end

  def down
    rename_table :interests, :interests
    rename_column :ratings, :interest_id, :interest_id
  end

end
