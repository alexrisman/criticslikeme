class ChangeSchoolsJobsToText < ActiveRecord::Migration
  def change
    remove_column :users, :jobs
    remove_column :users, :schools
    add_column :users, :jobs, :text
    add_column :users, :schools, :text
  end

end
