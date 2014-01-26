class DropMetrics < ActiveRecord::Migration
  def up
  	drop_table :metrics
  end

  def down
  	create_table :metrics do |t|
      t.string :ipaddress
      t.integer :user_id
      t.string :location
      t.string :user_agent

      t.timestamps
  	end	
  end
end
