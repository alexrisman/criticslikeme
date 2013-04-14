class AddEventIdToInterests < ActiveRecord::Migration
  def change
  	add_column :interests, :event_id, :integer
  end
end
