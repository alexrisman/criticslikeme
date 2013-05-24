class RenameUsersConnections < ActiveRecord::Migration
  def up
  	rename_table :users_connections, :connections_users
  end

  def down
  	rename_table :connections_users, :users_connections 
  end
end
