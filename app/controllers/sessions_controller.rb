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
    # if c.educations.all 
    #   @user.schools = c.educations.all
    #   a = Array.new
    #   @user.school_names = @user.schools.collect { |j| j.school_name }.uniq
    # end
    # if c.positions.all 
    #   @user.jobs = c.positions.all
    #   a = Array.new
    #   @user.company_names = @user.jobs.collect { |j| j.company.name }.uniq
    # end
    # if c.languages
    #   a = c.languages.all
    #   @user.languages = a.map {|l| l.language.name}
    #   @user.languages.delete("English")
    # else
    #   @user.languages = []
    # end
    # if c.connections.all
    #   a = c.connections.all
    #   a.each do |f|
    #     di = f.id
    #     if Connection.find_by_l_id(di)
    #       c = Connection.find_by_l_id(di)
    #       if !@user.connections.include?(c)
    #         @user.connections << c
    #       end
    #     else
    #       c = Connection.new
    #       c.first_name = f.first_name
    #       c.last_name = f.last_name
    #       c.full_name = "#{f.first_name}" + " " + "#{f.last_name}"
    #       c.headline_string = f.headline
    #       (f.location) ? c.location = f.location.name : false
    #       c.l_id = f.id
    #       c.picture_url = f.picture_url
    #       (f.site_standard_profile_request) ? c.profile_url = f.site_standard_profile_request.url : false
    #       c.save!
    #       @user.connections << c
    #     end
    #   end
    # end
    if c.positions
      a = c.positions.all
      a.each do |p|
        b = p.company.industry
        if Industry.find_by_name(b)
          f = Industry.find_by_name(b)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
          end
        else
          f = Industry.create(name: b)
          Poop.create(user: @user, ass: f)
        end
        b = p.company.name
        if Company.find_by_name(b)
          f = Company.find_by_name(b)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
          end
        else
          f = Company.create(name: b)
          Poop.create(user: @user, ass: f)
        end
      end
    end
    if c.educations
      a = c.educations.all
      a.each do |p|
        b = p.school_name
        if School.find_by_name(b)
          f = School.find_by_name(b)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
          end
        else
          f = School.create(name: b)
          Poop.create(user: @user, ass: f)
        end
      end
    end
    if c.skills
      a = c.skills.all
      a.each do |p|
        b = p.skill.name
        if Skill.find_by_name(b)
          f = Skill.find_by_name(b)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
          end
        else
          f = Skill.create(name: b)
          Poop.create(user: @user, ass: f)
        end
      end
    end
    if c.languages
      a = c.languages.all
      a.each do |p|
        b = p.language.name
        if Language.find_by_name(b)
          f = Language.find_by_name(b)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
          end
        else
          f = Language.create(name: b)
          Poop.create(user: @user, ass: f)
        end
      end
    end
    if c.industry
      b = c.industry
      if Industry.find_by_name(b)
        f = Industry.find_by_name(b)
        if !f.users.include?(@user)
          Poop.create(user: @user, ass: f)
        end
      else
        f = Industry.create(name: b)
        Poop.create(user: @user, ass: f)
      end
    end
    if c.location
      b = c.location.name
      if Location.find_by_name(b)
        f = Location.find_by_name(b)
        if !f.users.include?(@user)
          Poop.create(user: @user, ass: f)
        end
      else
        f = Location.create(name: b)
        Poop.create(user: @user, ass: f)
      end
    end
    if c.connections
      a = c.connections.all
      a.each do |f|
        di = f.id
        if Connection.find_by_l_id(di)
          f = Connection.find_by_l_id(di)
          if !f.users.include?(@user)
            Poop.create(user: @user, ass: f)
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
