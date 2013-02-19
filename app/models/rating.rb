class Rating < ActiveRecord::Base
  attr_accessible :stars, :user_id, :beer_id
  belongs_to :beer
  belongs_to :user
end
