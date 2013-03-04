class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on => :create
  before_save { |user| user.email = email.downcase }
  has_many :ratings
  has_many :wines, through: :ratings
  
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
  
  def highest_rated_wine
    if ratings
      ratings.order("stars DESC").first
    end
  end
  
  def rating_for(wine)
    ratings.select {|rate| rate.wine == wine ? rate : nil }.first
  end
  
  #Most Similar User
  def closest_neighbor
    User.all.each do |user|
    	if highest_rated_wine && user.highest_rated_wine && user != self && highest_rated_wine.wine_id == user.highest_rated_wine.wine_id
    		return user
    	end
  	end
  	
  	User.all.sample(1).first

  end

#Real most similar user
  def subbed_averages
    a = Array.new
    Wine.all.each do |wine|
      if rating_for(wine)
        a.push rating_for(wine).stars.to_f
      else
        a.push wine.average_rating
      end
    end
    a
  end



  def user_stars
    a = subbed_averages
    a
  end

  def user_stars_squared
    user_stars.map {|val| val*val}
  end
  
  def correlation(u)
    a = user_stars
    b = u.user_stars
    if a.uniq.size > 1 && b.uniq.size > 1
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
    else
      0
    end
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

  def critics_like_me
    similar_users.first(5)
  end

  def sim_list
    #a = correlation_list
    a = critics_like_me
    b = Array.new
    a.each do |user|
      b.push user.get_similarity
    end
    b
  end

  def sim_sum
    a = Array.new
    b = sim_list
    b.each do |s|
      a.push s.abs
    end
    a.inject{|sum,x| sum + x }
  end

  def weights
    a = sim_list
    b = sim_sum
    c = Array.new
    a.each do |s|
      c.push s / b
    end
    c
  end

<<<<<<< HEAD
  def clm_id
    a = critics_like_me
    b = Array.new
    a.each do |user|
      b.push user.get_user
    end
    c = Array.new
    b.each do |id|
      c.push User.find_by_id(id)
    end
    c
  end


  def predicted_rating_for(wine)
    #a = User.all :conditions => (self ? ["id != ?", self.id] : [])
    a = clm_id
    b = Array.new
    c = weights
    a.each do |user|
      if user.rating_for(wine)
        b.push user.rating_for(wine).stars
      else
        b.push wine.average_rating
      end
    end
    d = b.zip(c).map { |x,y| x*y }
    e = d.inject{|sum,x| sum + x }
    if e > 0
      e
    else
      0
    end
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
