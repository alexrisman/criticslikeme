class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :first_name
      t.string :last_name
      t.string :l_id
      t.string :profile_url
      t.string :location
      t.string :headline_string
      t.string :picture_url

      t.timestamps
    end
  end
end
