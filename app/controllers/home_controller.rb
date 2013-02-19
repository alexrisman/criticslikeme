class HomeController < ApplicationController
  before_filter :authorize, :only => ["index", "recommend"]
  def index
  end

  def recommend
  end

  def info
  end
end
