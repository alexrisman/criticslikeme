class AddBannerToEvents < ActiveRecord::Migration
  def self.up
    add_attachment :events, :banner
  end

  def self.down
    remove_attachment :events, :banner
  end
end
