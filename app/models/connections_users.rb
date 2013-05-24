class ConnectionsUsers < ActiveRecord::Base
  attr_accessible :connection_id, :user_id
end
