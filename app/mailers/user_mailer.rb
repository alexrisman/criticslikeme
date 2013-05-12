class UserMailer < ActionMailer::Base
  default from: "info@confr.us"
  
  def new_message(message)
      @user = message.recipient
      @message = message
      @url  = "http://confr.us"
      mail(:to => @user.email, :subject => "You've received a message on Confr")
    end
end
