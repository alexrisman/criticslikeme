class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :linkedin_token, :linkedin_secret, :linkedin_authhash, :picture_url, 
 :first_name, 
 :last_name, 
 :title,
 :industry, 
 :linkedin_url,
 :location_string, 
 :schools,
 :jobs,
 :school_names,
 :company_names
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #validates_presence_of :password, :on => :create
  #before_save { |user| user.email = email.downcase }
  has_many :ratings
  has_many :interests, through: :ratings
  serialize :schools 
  serialize :jobs
  serialize :school_names
  serialize :company_names
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
  #has_secure_password
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
    (Rating.find_all_by_user_id_and_interest_id(id, event.interests.map{|x| x.id}, :order=>"stars").map{|x| Interest.find(x.interest_id)}+ event.interests).uniq
  end

  def get_interests_for(event)
    a = Array.new
    event.interests.each do |i|
      a.push i.name
    end
    a
  end


  
  # #Most Similar User
  # def closest_neighbor
  #   User.all.each do |user|
  #   	if highest_rated_interest && user.highest_rated_interest && user != self && highest_rated_interest.interest_id == user.highest_rated_interest.interest_id
  #   		return user
  #   	end
  # 	end
  	
  # 	User.all.sample(1).first

  # end

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

  def coattendees(event)
    a = Array.new
    b = User.all :conditions => (self ? ["id != ?", self.id] : [])
    b.each do |user|
      if user.is_part_of?(event)
        a.push user
      end
    end
    a
  end
  def correlation_list(event)
    a = coattendees(event)
    c = Array.new
    a.each do |user|
      c.push SimilarUser.new(correlation(user), user.id)
    end
    c
  end

  
  def similar_users(event)
    a = correlation_list(event)
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
      User.find @user
    end 
  end

  class InterestVector 
    def initialize(a,b,c,d,e)
      @first, @second, @third, @fourth, @fifth = a, b, c, d, e 
    end
  end

  #Linkedin Matching

  def shares_location(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if location_string == u.location_string
        b.push u
      end
    end
    b
  end

  def shares_industry(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if industry == u.industry
        b.push u
      end
    end
    b
  end

  def shares_company(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if company_name 
        if company_name == u.company_name
          b.push u
        elsif company_name == u.last_company_name_1
          b.push u
        elsif company_name == u.last_company_name_2
          b.push u
        elsif company_name == u.last_company_name_3
          b.push u
        end
      end
    end
    b
  end

  def shares_last_company(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if last_company_name_1 
        if last_company_name_1 == u.company_name
          b.push u
        elsif last_company_name_1 == u.last_company_name_1
          b.push u
        elsif last_company_name_1 == u.last_company_name_2
          b.push u
        elsif last_company_name_1 == u.last_company_name_3
          b.push u
        end
      end
    end
    b
  end
  def shares_last_company_2(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if last_company_name_2 
        if last_company_name_2 == u.company_name
          b.push u
        elsif last_company_name_2 == u.last_company_name_1
          b.push u
        elsif last_company_name_2 == u.last_company_name_2
          b.push u
        elsif last_company_name_2 == u.last_company_name_3
          b.push u
        end
      end
    end
    b
  end
  def shares_last_company_3(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if last_company_name_3 
        if last_company_name_3 == u.company_name
          b.push u
        elsif last_company_name_3 == u.last_company_name_1
          b.push u
        elsif last_company_name_3 == u.last_company_name_2
          b.push u
        elsif last_company_name_3 == u.last_company_name_3
          b.push u
        end
      end
    end
    b
  end

  def shares_education(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if school_1 
        if school_1 == u.school_1
          b.push u
        elsif school_1 == u.school_2
          b.push u
        elsif school_1 == u.school_3
          b.push u
        end
      end
    end
    b
  end
  def shares_last_education_1(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if school_2 
        if school_2 == u.school_1
          b.push u
        elsif school_2 == u.school_2
          b.push u
        elsif school_2 == u.school_3
          b.push u
        end
      end
    end
    b
  end
  def shares_last_education_2(event)
    a = coattendees(event)
    b = Array.new
    a.each do |u|
      if school_3 
        if school_3 == u.school_1
          b.push u
        elsif school_3 == u.school_2
          b.push u
        elsif school_3 == u.school_3
          b.push u
        end
      end
    end
    b
  end

  # def school_names
  #   a = schools
  #   b = Array.new
  #   a.each do |s|
  #     b.push s.school_name
  #   end
  #   b.uniq
  # end
  # def company_names
  #   a = jobs
  #   b = Array.new
  #   a.each do |p|
  #     b.push p.company.name
  #   end
  #   b.uniq
  # end

  def shares_attributes(attri, comparison, people)
    c = Array.new
    comparison.each do |s|
      d = Array.new
      people.each do |u|
        e = u.attributes
        if e[attri]
          f = e[attri]
        else
          f = []
        end
        if f.include?(s)
          d.push u
        end
        # if d.length > 0
        #   c.push d
        # end
      end
      c.push d
    end
    c
    # if c.length > 0
    #   c
    # end
  end
  def shares_single_attribute(attri, comparison, people)
    c = Array.new
    people.each do |u|
      e = u.attributes
      f = e[attri]
      if f == comparison
        c.push u
      end
    end
    # if c.length > 0
    #   c
    # end
    c
  end
  def shares_attribute_list(event, attri)
    a = shares_attribute(event, attri)
    a.flatten.uniq
  end
 def shares_attribute(event, attri)
    a = coattendees(event)
    b = attributes
    c = b[attri]
    if c.kind_of?(Array)
      shares_attributes(attri, c, a)
    else
      shares_single_attribute(attri, c, a)
    end
  end
  # def shares_schools(event)
  #   a = coattendees(event)
  #   b = school_names
  #   c = Array.new
  #   b.each do |s|
  #     a.each do |u|
  #       d = Array.new
  #       if u.school_names.include?(s)
  #         d.push u
  #       end
  #       c.push d
  #     end
  #   end
  #   c
  # end
  # def shares_schools_with(user)
  #   b = school_names
  #   c = Array.new
  #   b.each do |s|
  #     if user.school_names.include?(s)
  #       c.push s
  #     end
  #   end
  #   c
  # end
  def shares_attributes_with(mine, his)
    d = Array.new
    mine.each do |m|
      if his.include?(m)
        d.push m
      end
    end
    if d.length > 0
      d
    end
  end
  def shares_single_attribute_with(mine, hers)
    if mine == hers
      mine
    end
  end

    
  def shares_attribute_with(user, attri)
    b = attributes
    c = attributes[attri]
    d = user.attributes
    if d[attri]
      e = d[attri]
    else
      e = []
    end
    if c.kind_of?(Array)
      shares_attributes_with(c, e)
    else
      if c == e
        c
      end
    end
  end

  def attribute_list
    a = attributes
    b = Array.new
    a.each_key {|key| b.push key}
    b
  end

  def shared_list(user)
    a = attribute_list
    b = Array.new
    a.each do |attri|
      if attri.kind_of?(String) || attri.kind_of?(Array)
        b.push shares_attribute_with(user, attri)
      end
    end
    c = b.flatten.uniq.compact
  end








    
  
end
