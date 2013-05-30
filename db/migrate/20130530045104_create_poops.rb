class CreatePoops < ActiveRecord::Migration
  def change
    create_table :poops do |t|
      t.integer :user_id
      t.integer :ass_id
      t.string :ass_type

      t.timestamps
    end
  end
end
