class Beer < ActiveRecord::Base
  attr_accessible :info, :location, :name, :price
end
