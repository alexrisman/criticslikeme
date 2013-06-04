class SessionsController < ApplicationController
  def create
    client = LinkedIn::Client.new("q1iihtxz0jdp", "zcRTqafcns6LqZwG")
    omniauth = request.env["omniauth.auth"]
    @user = User.find_or_create_by_linkedin_authhash(omniauth['uid'])
    @user.update_attributes(
      :linkedin_token => omniauth['credentials']['token'],
      :linkedin_secret => omniauth['credentials']['secret']
    )
    
    cookies[:user_token] ={ :value =>  @user.token, :expires => Time.now + 20.days}
    
    if (!@user.name) 
      @user.updateFromLI
    end
  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
  def notloggedin
  end
  
end
