class SessionsController < ApplicationController
  def create
    client = LinkedIn::Client.new("q1iihtxz0jdp", "zcRTqafcns6LqZwG")
    omniauth = request.env["omniauth.auth"]
    @user = User.find_or_create_by_linkedin_authhash(omniauth['uid'])
    @user.linkedin_token = omniauth['credentials']['token']
    @user.linkedin_secret = omniauth['credentials']['secret']
    @user.save!

    cookies[:user_token] = @user.token
    c = client_profile
    @user.location_string = c.location.name
    @user.first_name = c.first_name
    @user.last_name = c.last_name
    @user.picture_url = c.picture_url
    @user.title = c.headline
    @user.industry = c.industry
    @user.email = c.email_address
    @user.linkedin_url = c.public_profile_url
    if c.positions
      c.positions.all.each do |p|
        f = Industry.find_or_create_by_name(p.company.industry)
        Poop.create(user: @user, ass: f)
        
        f = Company.find_or_create_by_name(p.company.name)
        Poop.create(user: @user, ass: f)
      end
    end
    
    if c.educations
      c.educations.all.each do |p|
        f = School.find_or_create_by_name(p.school_name)
        Poop.create(user: @user, ass: f)
      end
    end
    
    if c.skills
      c.skills.all.each do |p|
        f = Skill.find_or_create_by_name(p.skill.name)
        Poop.create(user: @user, ass: f)
      end
    end
    
    if c.languages
      c.languages.all.each do |p|
        f = Language.find_or_create_by_name(p.language.name)
        Poop.create(user: @user, ass: f)
      end
    end
    
    if c.industry
      f = Industry.find_or_create_by_name(c.industry)
      Poop.create(user: @user, ass: f)
    end
    
    if c.location
      f = Location.find_or_create_by_name(c.location.name)
      Poop.create(user: @user, ass: f)
    end
    
    if c.connections
      c.connections.all.each do |f|
        di = f.id
        if con=Connection.find_by_l_id(di)
          if !con.users.include?(@user)
            Poop.create(user: @user, ass: con)
          end
        else
          c = Connection.new
          c.first_name = f.first_name
          c.last_name = f.last_name
          c.full_name = "#{f.first_name}" + " " + "#{f.last_name}"
          c.headline_string = f.headline
          (f.location) ? c.location = f.location.name : false
          c.l_id = f.id
          c.picture_url = f.picture_url
          (f.site_standard_profile_request) ? c.profile_url = f.site_standard_profile_request.url : false
          c.save!
          Poop.create(user: @user, ass: c)
        end
      end
    end
  






    @user.name = [@user.first_name, " ", @user.last_name].join
    @user.save!
  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
  def notloggedin
  end
  
end
