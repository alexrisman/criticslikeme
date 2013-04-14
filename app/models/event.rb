class Event < ActiveRecord::Base
  attr_accessible :date, :details, :name
  has_many :interests
end
