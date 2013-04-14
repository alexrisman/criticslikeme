class HomeController < ApplicationController
  before_filter :authorize, :only => ["recommend"]
  def index
  end

  def recommend
  end

  def info
  end
end
