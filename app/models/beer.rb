class Beer < ActiveRecord::Base
  attr_accessible :info, :location, :name, :price, :photo
  belongs_to :user
  has_many :ratings
  has_many :users, through: :ratings

  #photo stuffs
  # s3 Credentials
  options = if Rails.env.production? 
    {:storage => :s3,
      :bucket => ENV['S3_BUCKET_NAME'],
      :s3_credentials => {
       :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
       :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
     }
  else
     {}  
  end
  has_attached_file :photo, options
  validates_attachment_size :photo, :less_than => 2.megabytes
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']
  
  def value_ratio
    a = average_rating
  	a / price
  end

  def average_rating
    a = ratings.map {|rate| rate.stars}
    a.inject{ |sum, el| sum + el }.to_f / a.size
  end
  
  	
end
