class Rating < ActiveRecord::Base
  attr_accessible :stars, :user_id, :interest_id, :review
  belongs_to :interest
  belongs_to :user
  
  scope :toprated, order("stars DESC")
  scope :lowrated, order("stars ASC")
end
