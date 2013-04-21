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
    redirect_to root_path, :notice => "Logged in!"
  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
  def chat
  end
  
end
