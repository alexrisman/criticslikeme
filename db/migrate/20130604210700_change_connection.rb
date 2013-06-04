class ChangeConnection < ActiveRecord::Migration
  def up
  	rename_column :connections, :full_name, :name
  end

  def down
  	rename_column :connections, :name, :full_name
  end
end
