class Rating < ActiveRecord::Base
  attr_accessible :stars, :user_id, :wine_id, :review
  belongs_to :wine
  belongs_to :user
  
  scope :toprated, order("stars DESC")
  scope :lowrated, order("stars ASC")
end
