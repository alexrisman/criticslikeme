class EventsController < ApplicationController
  before_filter :authorize, :only => ["index", "new", "show", "joining"]
  
  # GET /events
  # GET /events.json
  def index
    @owned_events = current_user.owned_events
    @events = current_user.events

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @attendance_count = @event.users.count + 1 #plus 1 for admin
    #@sorted_ratings = current_user.get_sorted_ratings_for(@event)
    
    @shares_industry = current_user.shares_industry(@event)
    @shares_location = current_user.shares_location(@event)
    @shares_company = current_user.shares_company(@event)
    @shares_last_company = current_user.shares_last_company(@event)
    @shares_last_company_2 = current_user.shares_last_company_2(@event)
    @shares_last_company_3 = current_user.shares_last_company_3(@event)
    @shares_education = current_user.shares_education(@event)
    @shares_last_education_1 = current_user.shares_last_education_1(@event)
    @shares_last_education_2 = current_user.shares_last_education_2(@event)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    if current_user.name != "Yee Wai" && current_user.name && "Patrick Hadley" && current_user.name != "Alex Risman"
      redirect_to root_path
    else
      @event = Event.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @event }
      end
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  def join
    @event = Event.find_by_token params[:token]
    
    if current_user && current_user.is_part_of?(@event)
      redirect_to @event
    end
    
    @user = User.new
  end
  
  def joining
    @event = Event.find(params[:event_id])
    current_user.events << @event
    redirect_to @event
  end
end
