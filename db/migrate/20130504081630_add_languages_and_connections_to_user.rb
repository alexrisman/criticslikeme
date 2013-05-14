class AddLanguagesAndConnectionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :languages, :text
    add_column :users, :connections, :text
  end
end
