class Event < ActiveRecord::Base
  attr_accessible :date, :details, :name, :token, :admin_id
  has_many :interests
  has_and_belongs_to_many :users
  belongs_to :admin, :class_name => "User"
  
  before_create { generate_token(:token) }
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Event.exists?(column => self[column])
  end
end
