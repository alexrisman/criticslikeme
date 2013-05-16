class ChangeSchoolNamesAndCompnayNamesToText < ActiveRecord::Migration
  def change
    remove_column :users, :school_names
    remove_column :users, :company_names
    add_column :users, :school_names, :text
    add_column :users, :company_names, :text
  end


end
