class AddMoreStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    rename_column :users, :password, :password_digest
  end
end
