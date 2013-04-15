class HomeController < ApplicationController
  before_filter :authorize, :only => ["recommend"]
  def index
    if (current_user)
      redirect_to events_path
    end
  end

  def recommend
  end

  def info
  end
end
