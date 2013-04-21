class AddLinkedinInfoToUSer < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_authhash, :string
    add_column :users, :linkedin_token, :string
    add_column :users, :linkedin_secret, :string
  end
end
