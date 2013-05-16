class AddSchoolNamesAndCompanyNamesToUser < ActiveRecord::Migration
  def change
    add_column :users, :school_names, :string
    add_column :users, :company_names, :string
  end
end
