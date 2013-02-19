class RatingsController < ApplicationController
  def create
    @rating = Rating.new(params[:rating])
    respond_to do |format|
      if @rating.save
        format.html { redirect_to beers_rate_path(@rating.beer), notice: 'Rating was successfully created.' }
        format.json { render json: @rating.beer, status: :created, location: @beer }
      else
        format.html { redirect_to beers_rate_path(@rating.beer), notice: 'Error' }
        format.json { render json: @rating.beer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to beers_rate_path(@rating.beer), notice: 'Rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to beers_rate_path(@rating.beer), notice: 'Rating failed to updated.' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end
end
