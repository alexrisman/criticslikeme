class AddFullNameToConnection < ActiveRecord::Migration
  def change
    add_column :connections, :full_name, :string
  end
end
