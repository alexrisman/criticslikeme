class InterestsController < ApplicationController
  before_filter :authorize, :only => "rate"
  # GET /interests
  # GET /interests.json
  def index
    @interests = Interest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interests }
    end
  end

  # GET /interests/1
  # GET /interests/1.json
  def show
    @interest = Interest.find(params[:id])
    if (current_user)
      @ratings = current_user.ratings.find_by_interest_id(@interest.id)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interest }
    end
  end
  
  def rate
    @interest = Interest.find(params[:id])
    @nextinterest = Interest.order("id ASC").where("id > ?", @interest.id).first
    @rating = current_user.ratings.find_by_interest_id(@interest.id) || Rating.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interest }
    end
  end
  
  def recommend
    @match = current_user.closest_neighbor
    @recs = @match.ratings.where("stars>2")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interest }
    end
  end
  
  # GET /interests/new
  # GET /interests/new.json
  def new
    @interest = Interest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interest }
    end
  end
  
  def view_ratings
    b = Interest.find(1)
    if current_user
      @ratings = current_user.similar_users.map {|sim_user|
          User.find(sim_user.get_user).rating_for(b)
        }.flatten
    else
      @ratings = b.ratings
    end
    render :view_ratings, :layout => false
  end

  # GET /interests/1/edit
  def edit
    @interest = Interest.find(params[:id])
  end

  # POST /interests
  # POST /interests.json
  def create
    @interest = Interest.new(params[:interest])

    respond_to do |format|
      if @interest.save
        format.html { redirect_to @interest, notice: 'Interest was successfully created.' }
        format.json { render json: @interest, status: :created, location: @interest }
      else
        format.html { render action: "new" }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /interests/1
  # PUT /interests/1.json
  def update
    @interest = Interest.find(params[:id])

    respond_to do |format|
      if @interest.update_attributes(params[:interest])
        format.html { redirect_to @interest, notice: 'Interest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interests/1
  # DELETE /interests/1.json
  def destroy
    @interest = Interest.find(params[:id])
    @interest.destroy

    respond_to do |format|
      format.html { redirect_to interests_url }
      format.json { head :no_content }
    end
  end
end
