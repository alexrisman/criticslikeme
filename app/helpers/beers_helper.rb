module BeersHelper
	def rating_ballot
    if @rating = current_user.ratings.find_by_beer_id(params[:id])
        @rating
    else
        current_user.ratings.new
    end
end
end
