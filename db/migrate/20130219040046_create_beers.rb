class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.string :info
      t.integer :price
      t.string :location

      t.timestamps
    end
  end
end
