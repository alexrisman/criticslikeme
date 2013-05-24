class Connection < ActiveRecord::Base
  attr_accessible :first_name, :full_name, :headline_string, :l_id, :last_name, :location, :picture_url, :profile_url
  has_and_belongs_to_many :users
end
