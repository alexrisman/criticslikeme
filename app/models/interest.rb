class Interest < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  belongs_to :event
  has_many :ratings
  has_many :users, through: :ratings
  
  def value_ratio
    a = average_rating
  	a / price
  end

  def average_rating
    if ratings && ratings.length > 0
      a = ratings.map {|rate| rate.stars}
      a.inject{ |sum, el| sum + el }.to_f / a.size
    else
      0
    end
  end
  
  	
end
