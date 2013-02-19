class AddUserIdAndBeerIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :user_id, :string
    add_column :ratings, :beer_id, :string
  end
end
