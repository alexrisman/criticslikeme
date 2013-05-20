class RemoveConnectionsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :connections
  end

  def down
    add_column :users, :connections, :text
  end
end
