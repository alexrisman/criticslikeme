class WinesController < ApplicationController
  before_filter :authorize, :only => "rate"
  # GET /wines
  # GET /wines.json
  def index
    @wines = Wine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wines }
    end
  end

  # GET /wines/1
  # GET /wines/1.json
  def show
    @wine = Wine.find(params[:id])
    if (current_user)
      @ratings = current_user.ratings.find_by_wine_id(@wine.id)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wine }
    end
  end
  
  def rate
    @wine = Wine.find(params[:id])
    @nextwine = Wine.order("id ASC").where("id > ?", @wine.id).first
    @rating = current_user.ratings.find_by_wine_id(@wine.id) || Rating.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wine }
    end
  end
  
  def recommend
    @match = current_user.closest_neighbor
    @recs = @match.ratings.where("stars>2")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wine }
    end
  end
  
  # GET /wines/new
  # GET /wines/new.json
  def new
    @wine = Wine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wine }
    end
  end
  
  def wine
    #demo purposes:
    #Auto-login
    if (!current_user)
      cookies[:user_token] = {:value => User.first.token}
    end
    
    #critics like me ratings
    b = Wine.find(1)
    if current_user
      @ratings = current_user.similar_users.map {|sim_user|
          User.find(sim_user.get_user).rating_for(b)
        }.flatten
    end
    
    @recent_ratings = b.ratings
    @toprated_ratings = b.ratings.toprated
    @lowrated_ratings = b.ratings.lowrated
    #Demo ratings
    @patrick_ratings = if (u = User.find_by_name("patrick")) 
      u.similar_users.map {|sim_user|
        User.find(sim_user.get_user).rating_for(b)
      }.flatten 
      else
         b.ratings
      end
    @alex_ratings = if (u = User.find_by_name("alex")) 
        u.similar_users.map {|sim_user|
          User.find(sim_user.get_user).rating_for(b)
        }.flatten 
        else
           b.ratings
        end
    @yee_ratings =  if (u = User.find_by_name("Yee")) 
          u.similar_users.map {|sim_user|
            User.find(sim_user.get_user).rating_for(b)
          }.flatten 
          else
             b.ratings
          end
    render :wine, :layout => false
  end
  
  def view_ratings
    b = Wine.find(1)
    if current_user
      @ratings = current_user.similar_users.map {|sim_user|
          User.find(sim_user.get_user).rating_for(b)
        }.flatten
    else
      @ratings = b.ratings
    end
    render :view_ratings, :layout => false
  end

  # GET /wines/1/edit
  def edit
    @wine = Wine.find(params[:id])
  end

  # POST /wines
  # POST /wines.json
  def create
    @wine = Wine.new(params[:wine])

    respond_to do |format|
      if @wine.save
        format.html { redirect_to @wine, notice: 'Wine was successfully created.' }
        format.json { render json: @wine, status: :created, location: @wine }
      else
        format.html { render action: "new" }
        format.json { render json: @wine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wines/1
  # PUT /wines/1.json
  def update
    @wine = Wine.find(params[:id])

    respond_to do |format|
      if @wine.update_attributes(params[:wine])
        format.html { redirect_to @wine, notice: 'Wine was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wines/1
  # DELETE /wines/1.json
  def destroy
    @wine = Wine.find(params[:id])
    @wine.destroy

    respond_to do |format|
      format.html { redirect_to wines_url }
      format.json { head :no_content }
    end
  end
end
