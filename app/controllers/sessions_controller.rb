class SessionsController < ApplicationController
  # Manages the user login sessions/cookies
  def new
  end
  
  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password] ) 
      if (params[:remember] == "true")
        cookies.permanent[:user_token] = {:value => user.token}
      else
        cookies[:user_token] = {:value => user.token}
      end
      flash.now.alert = "Logged in! Awwww yeah."
      redirect_to root_path, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      redirect_to root_path, notice: 'Invalid email or password'
    end
  end
  
  def destroy
    cookies.delete :user_token
    redirect_to root_path
  end
  
  def chat
  end
  
end
