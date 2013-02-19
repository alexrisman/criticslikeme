class Beer < ActiveRecord::Base
  attr_accessible :info, :location, :name, :price, :photo
  belongs_to :user

  #photo stuffs
  
  has_attached_file :photo
  validates_attachment_size :photo, :less_than => 2.megabytes
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
  
  def value_ratio
  	price/rating.stars
  end
  
  	
end
