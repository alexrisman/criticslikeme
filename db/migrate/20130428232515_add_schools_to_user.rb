class AddSchoolsToUser < ActiveRecord::Migration
  def change
    add_column :users, :schools, :string
  end
end
