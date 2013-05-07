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
    if c.educations.all 
      @user.schools = c.educations.all
      a = Array.new
      @user.school_names = @user.schools.collect { |j| j.school_name }.uniq
    end
    if c.positions.all 
      @user.jobs = c.positions.all
      a = Array.new
      @user.company_names = @user.jobs.collect { |j| j.company.name }.uniq
    end
    if c.languages
      a = c.languages.all
      @user.languages = a.map {|l| l.language.name}
      @user.languages.delete("English")
    else
      @user.languages = []
    end
    if c.connections.all
      a = c.connections.all
      @user.connections = []
      a.each do |f|
        n = "#{f.first_name}" + " " + "#{f.last_name}"
        b = {name: n, headline: f.headline, 
          url: (f.site_standard_profile_request) ? f.site_standard_profile_request.url : nil}
        @user.connections.push b unless b[:url] == nil
      end
    end

    @user.name = [@user.first_name, " ", @user.last_name].join
    @user.save!

    @closest_event = Event.all.select {|e| e.date > Time.now}.first
  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
end
