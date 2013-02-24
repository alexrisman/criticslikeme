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
  
  def highest_rated_beer
    if ratings
      ratings.order("stars DESC").first
    end
  end
  
  def rating_for(beer)
    ratings.select {|rate| rate.beer == beer ? rate : nil }
  end
  
  #Most Similar User
  def closest_neighbor
    User.all.each do |user|
    	if highest_rated_beer && user.highest_rated_beer && user != self && highest_rated_beer.beer_id == user.highest_rated_beer.beer_id
    		return user
    	end
  	end
  	
  	User.all.sample(1).first

  end

#Real most similar user
  def user_stars
    ratings.map {|rate| rate.stars}
  end

  def user_stars_squared
    user_stars.map {|val| val*val}
  end
  
  def correlation(u)
    a = user_stars
    b = u.user_stars
    c = a.zip(b).map { |x,y| x*y } 
    d = a.inject{|sum,x| sum + x }
    e = b.inject{|sum,x| sum + x }
    f = user_stars_squared
    g = u.user_stars_squared
    h = f.inject{|sum,x| sum + x }
    i = g.inject{|sum,x| sum + x }
    k = c.inject{|sum,x| sum + x }
    n = a.count
    (((n * k) - (d * e)) / (((n * h) - d**2) * ((n * i) - e**2))**0.5)
    
  end

  def correlation_list
    a = Array.new
    b = User.all :conditions => (self ? ["id != ?", self.id] : [])
    b.each do |user|
      a.push SimilarUser.new(correlation(user), user.id)
    end
    a
  end
  
  def similar_users
    a = correlation_list
    a.sort{|a,b| b.get_similarity <=>  a.get_similarity}

  end

  def real_closest_neighbor
    a = similar_users
    b = a.first.get_user
    User.find_by_id(b)
  end

  class SimilarUser
    def initialize(w,h)
      @similarity, @user = w, h
    end

    def get_similarity
      @similarity
    end

    def get_user
      @user
    end 
  end




    
  
end
