class UsersController < ApplicationController
  before_filter :authorize, :only=> ["edit", "update"]
  # GET /users
  # GET /users.json
  def index
    #@users = User.all
    @search = User.search(params[:q])
    @users = @search.result.sort{|x, y| current_user.shared_count(y) <=> current_user.shared_count(x) }
    @event = Event.find_by_token(params[:q][:events_token_cont])
    @coattendees = current_user.coattendees(@event)
    @search_value = params[:q][:name_or_school_names_or_company_names_or_location_string_or_industry_or_languages_cont]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: current_user }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if !authorize_edit(@user)
      render :template => "sessions/restricted"
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        if (params[:event_id])
          @user.events << Event.find(params[:event_id])
        end
        cookies[:user_token] = {:value => @user.token}
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to logout_path }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'You cannot delete other users' }
        format.json { head :no_content }
      end
    end

  end
end
