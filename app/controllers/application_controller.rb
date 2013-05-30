class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||=User.find_by_token(cookies[:user_token]) if cookies[:user_token]
  end
  helper_method :current_user
  
  def record_metric
    m = Metric.new
    if current_user
      m.user = current_user
    end
    m.ipaddress = request.remote_ip
    m.location = request.fullpath
    m.user_agent = request.user_agent
    m.save!
  end
  helper_method :record_metric
  before_filter :record_metric
  
  def client_profile
    if current_user
      @client = LinkedIn::Client.new("q1iihtxz0jdp", "zcRTqafcns6LqZwG")
      @client.authorize_from_access(current_user.linkedin_token, current_user.linkedin_secret)
      @client.profile(:fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections", "educations", "three-past-positions", "three-current-positions", "positions", "languages", "skills"])
    end
  end
  helper_method :client_profile
  
  def messages_between(user1, user2) 
    Message.where{((sender_id == user1.id) & (recipient_id == user2.id)) | ((sender_id == user2.id) & (recipient_id == user1.id))}
  end
  helper_method :messages_between
  
  def get_unread_message_count (user)
    Message.where{(recipient_id == user.id) & (is_read == false)}.count
  end
  helper_method :get_unread_message_count
  
  def authorize 
    redirect_to loginplz_path if current_user.nil?
  end

  def authorize_edit(user)
    current_user == user
  end
  def authorize_edit2(event)
    current_user.id == event.admin_id
  end

end

