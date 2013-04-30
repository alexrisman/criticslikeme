class AddJobsToUser < ActiveRecord::Migration
  def change
    add_column :users, :jobs, :string
  end
end
