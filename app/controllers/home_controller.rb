class HomeController < ApplicationController
  before_filter :authorize, :only => ["recommend"]
  def index
    if (current_user)
      redirect_to events_path
    end
    @banners = Event.all.map {|e| e.banner.url }
  end

  def recommend
  end

  def about
    @users = [User.find_by_name("Yee Wai"), User.find_by_name("Alex Risman"), User.find_by_name("Patrick Hadley")].compact
  end
end
