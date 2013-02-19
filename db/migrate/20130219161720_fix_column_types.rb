class FixColumnTypes < ActiveRecord::Migration
  def change
    remove_column :ratings, :beer_id
    remove_column :ratings, :user_id
    add_column :ratings, :user_id, :integer
    add_column :ratings, :beer_id, :integer
    change_column :beers, :info, :text
  end

end
