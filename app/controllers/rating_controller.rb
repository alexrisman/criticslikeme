class RatingsController < ApplicationController
  def new
    @rating = Rating.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beer }
    end
  end

  def create
    @rating = Rating.new(params[:rating])

    if @rating.save 
    	#:notice => "Thank you for purchasing!"
    end
  end
end
