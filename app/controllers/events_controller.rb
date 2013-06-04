class EventsController < ApplicationController
  before_filter :authorize, :only => ["index", "new", "show", "joining"]
  
  # GET /events
  # GET /events.json
  def index
    @events = current_user.owned_events + current_user.events
    @past_events = @events.select {|e| e.date < Time.now}.reverse
    @upcoming_events = @events.select {|e| e.date > Time.now}
    @all_events = Event.all.reverse
    @other_events = @all_events.select {|e| !@events.include?(e) }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find_by_id(params[:id])
    @search = User.search(params[:q])
    if !@event
      render :template => "sessions/notfound"
    else
      @attendance_count = @event.users.count + 1 #plus 1 for admin
      #@sorted_ratings = current_user.get_sorted_ratings_for(@event)
      
      @shares_industry = current_user.shared_asses(@event, "Industry")
      @shares_location = current_user.shared_asses(@event, "Location")
      @shares_companies = current_user.shared_asses(@event, "Company")
      @shares_schools = current_user.shared_asses(@event, "School")
      @coattendees = current_user.coattendees(@event)
      @shares_languages = current_user.shared_asses(@event, "Language")
      #@shares_connections = current_user.shares_attribute_list(@event, "connections")

      @index = 0
      
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @event }
      end
    end
  end


  # GET /events/new
  # GET /events/new.json
  def new
    if current_user.name != "Yee Wai" && current_user.name != "Patrick Hadley" && current_user.name != "Alex Risman"
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
    if !authorize_edit2(@event)
      render :template => "sessions/restricted"
    end
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
