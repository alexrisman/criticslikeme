class Poop < ActiveRecord::Base
  attr_accessible :ass_id, :ass_type, :user_id, :user, :ass
  belongs_to :ass, :polymorphic => true
  belongs_to :user
end
