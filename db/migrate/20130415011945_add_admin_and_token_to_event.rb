class AddAdminAndTokenToEvent < ActiveRecord::Migration
  def change
    add_column :events, :admin_id, :integer
    add_column :events, :token, :string
  end
end
