class RatingsController < ApplicationController
  def create
    @rating = Rating.new(params[:rating])
    respond_to do |format|
      if @rating.save
        format.html { redirect_to interests_rate_path(@rating.interest), notice: 'Rating was successfully created.' }
        format.json { render json: @rating.interest, status: :created, location: @interest }
      else
        format.html { redirect_to interests_rate_path(@rating.interest), notice: 'Error' }
        format.json { render json: @rating.interest.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to interests_rate_path(@rating.interest), notice: 'Rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to interests_rate_path(@rating.interest), notice: 'Rating failed to updated.' }
        format.json { render json: @interest.errors, status: :unprocessable_entity }
      end
    end
  end
end
