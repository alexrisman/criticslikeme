class Event < ActiveRecord::Base
  attr_accessible :date, :details, :name, :token, :admin_id, :banner
  has_many :interests
  has_and_belongs_to_many :users
  belongs_to :admin, :class_name => "User"
  default_scope order("date")
  
  options = if Rails.env.production? && ENV['S3_BUCKET_NAME']
    {:storage => :s3,
      :bucket => ENV['S3_BUCKET_NAME'],
      :s3_credentials => {
       :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
       :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
       :default_url => "missing.jpg"
     }
  else
     {:default_url => "missing.jpg"}  
  end
  has_attached_file :banner, options
  
  before_create { generate_token(:token) }
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Event.exists?(column => self[column])
  end
end
