class CreateUsersConnections < ActiveRecord::Migration
  def change
    create_table :users_connections, :id => false do |t|
      t.integer :user_id
      t.integer :connection_id

      
    end
  end
end
