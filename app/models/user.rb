class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on => :create
  before_save { |user| user.email = email.downcase }
  has_many :ratings
  has_many :beers, through: :ratings
  
  #Token to store in cookie
  before_create { generate_token(:token) }
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  #Password Stuffs
  has_secure_password
  def self.authenticate(token, password)
    find_by_token(token).try(:authenticate, password)
  end
  #highest rating
  def highest_rating
  	ratings.max_by do |element|
  		element.stars
  	end 
  end
  
  #Most Similar User
  def closest_neighbor
    User.all.each do |user|
    	if highest_rating && user.highest_rating && user != self && highest_rating.beer_id == user.highest_rating.beer_id
    		return user
    	end
  	end
  	
  	User.all.sample(1).first

  end
  	
  
end
