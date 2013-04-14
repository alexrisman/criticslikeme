class RemoveOldFieldsFromInterests < ActiveRecord::Migration
  def up
    remove_column :interests, :info
    remove_column :interests, :location
    remove_column :interests, :price
    remove_column :interests, :photo_file_name
    remove_column :interests, :photo_content_type
    remove_column :interests, :photo_file_size
    remove_column :interests, :photo_updated_at
  end

  def down
    add_column :interests, :info, :string
    add_column :interests, :location, :string
    add_column :interests, :price, :float
    add_column :interests, :photo_file_name, :string
    add_column :interests, :photo_content_type, :string
    add_column :interests, :photo_file_size, :integer
    add_column :interests, :photo_updated_at, :datetime
  end
end
