class DropConnectionsUsers < ActiveRecord::Migration
  def up
  	drop_table :connections_users
  end

  def down
  	create_table :connections_users, :id => false do |t|
      t.integer :connection_id
      t.integer :user_id
    end
  end
end
