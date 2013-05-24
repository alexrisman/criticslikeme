class Metric < ActiveRecord::Base
  attr_accessible :ipaddress, :location, :user_agent, :user_id
  belongs_to :user
  
end
