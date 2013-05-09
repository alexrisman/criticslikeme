class MessagesController < ApplicationController
  before_filter :authorize
  # GET /messages
  # GET /messages.json
  def index
    @users = (Message.pluck(:sender_id) + Message.pluck(:recipient_id)).uniq.delete_if {|x| x == current_user.id}.map{|x| User.find_by_id(x)}.reverse.compact

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @user = User.find_by_id(params[:user_id])
    if !@user
      render :template => "sessions/notfound"
    else
      if current_user == @user
        @common_ground = ["Our records indicate that you are in fact you, and what you have in common with you is everything. What an incredible coincidence!"]
      else
        a = current_user.shared_list(@user).push current_user.shared_connections(@user)
        @common_ground = a.flatten.compact
      end
      @messages = messages_between(current_user, @user)
      @message = Message.new
      
      #Set messages to current_user as read
      @messages.each do |m| 
        if m.recipient == current_user && m.is_read == false
          m.is_read = true;
          m.save!
        end
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @message }
      end
    end
  end


  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to view_messages_path(@message.recipient), notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      end
    end
  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
