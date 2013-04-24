class SessionsController < ApplicationController
  # Manages the user login sessions/cookies
  def new
  end
  
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
    #current = c.three_current_positions.all
    (c.three_current_positions.all) ? @user.company_name = c.three_current_positions.all[0].company.name : false
    @user.linkedin_url = c.public_profile_url
    arr = c.three_past_positions.all
    if arr[0]
      @user.last_company_name_1 = arr[0].company.name
      @user.last_title_1 = c.three_past_positions.all[0].title
      @user.last_industry_1 = c.three_past_positions.all[0].company.industry
    end
    if arr[1]
      @user.last_company_name_2 = arr[1].company.name
      @user.last_title_2 = c.three_past_positions.all[1].title
      @user.last_industry_2 = c.three_past_positions.all[1].company.industry
    end
    if arr[2]
      @user.last_company_name_3 = arr[2].company.name
      @user.last_title_3 = c.three_past_positions.all[2].title
      @user.last_industry_3 = c.three_past_positions.all[2].company.industry
    end
    ed = c.educations.all
    (ed[0]) ? @user.school_1 = ed[0].school_name : false
    (ed[1]) ? @user.school_2 = ed[1].school_name : false
    (ed[2]) ? @user.school_3 = ed[2].school_name : false
    @user.name = [@user.first_name, " ", @user.last_name].join
    

    @user.save!

  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
  def chat
  end
  
end
