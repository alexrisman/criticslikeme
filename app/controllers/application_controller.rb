class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||=User.find_by_token!(cookies[:user_token]) if cookies[:user_token]
  end
  helper_method :current_user
  
  def authorize 
    redirect_to login_url alert: "Not logged in!" if current_user.nil?
  end
end
