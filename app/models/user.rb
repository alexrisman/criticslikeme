class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on => :create
  before_save { |user| user.email = email.downcase }
  has_many :ratings
  has_many :interests, through: :ratings
  
  has_and_belongs_to_many :events
  has_many :owned_events, :class_name => "Event", :foreign_key => "admin_id"
  
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
  
  def highest_rated_interest
    if ratings
      ratings.order("stars DESC").first
    end
  end
  
  def rating_for(interest)
    ratings.select {|rate| rate.interest == interest ? rate : nil }.first
  end
  
  def is_part_of?(event)
    events.exists?(event) || owned_events.exists?(event)
  end
  
  def get_sorted_interests_for(event)
    (Rating.find_all_by_user_id_and_interest_id(id, event.interests.map{|x| x.id}, :order=>"stars").map{|x| Interest.find(x.id)}+ event.interests).uniq
    
  end
  
  #Most Similar User
  def closest_neighbor
    User.all.each do |user|
    	if highest_rated_interest && user.highest_rated_interest && user != self && highest_rated_interest.interest_id == user.highest_rated_interest.interest_id
    		return user
    	end
  	end
  	
  	User.all.sample(1).first

  end

#Real most similar user
  def subbed_averages
    a = Array.new
    Interest.all.each do |interest|
      if rating_for(interest)
        a.push rating_for(interest).stars.to_f
      else
        a.push interest.average_rating
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

  def percent_match(user)
    a = correlation(user)
    b = (a * 100).round 
    b
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


  def predicted_rating_for(interest)
    #a = User.all :conditions => (self ? ["id != ?", self.id] : [])
    a = clm_id
    b = Array.new
    c = weights
    a.each do |user|
      if user.rating_for(interest)
        b.push user.rating_for(interest).stars
      else
        b.push interest.average_rating
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
