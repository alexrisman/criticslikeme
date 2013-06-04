class AddLIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :l_id, :string
  end
end
