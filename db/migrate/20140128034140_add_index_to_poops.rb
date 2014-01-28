class AddIndexToPoops < ActiveRecord::Migration
  def change
  	add_index :poops, :user_id
  end
end
