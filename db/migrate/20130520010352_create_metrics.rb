class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :ipaddress
      t.integer :user_id
      t.string :location
      t.string :user_agent

      t.timestamps
    end
  end
end
