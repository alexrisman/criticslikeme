class Rating < ActiveRecord::Base
  attr_accessible :stars, :user_id, :beer_id, :review
  belongs_to :beer
  belongs_to :user
  
  scope :toprated, order("stars DESC")
  scope :lowrated, order("stars ASC")
end
