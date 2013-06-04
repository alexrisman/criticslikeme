class Company < ActiveRecord::Base
  attr_accessible :name
  has_many :poops, :as => :ass
  has_many :users, :through => :poops
end
