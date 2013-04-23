class AddLastCompanyName2AndLastTitle2AndLastIndustry2AndLastLocation2AndLastCompanyName3AndLastTitle3AndLastIndustry3AndLastLocation3AndLocationAndSchool1AndSchool2AndSchool3ToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_company_name_2, :string
    add_column :users, :last_title_2, :string
    add_column :users, :last_industry_2, :string
    add_column :users, :last_location_2, :string
    add_column :users, :last_company_name_3, :string
    add_column :users, :last_title_3, :string
    add_column :users, :last_industry_3, :string
    add_column :users, :last_location_3, :string
    add_column :users, :location_string, :string
    add_column :users, :school_1, :string
    add_column :users, :school_2, :string
    add_column :users, :school_3, :string
  end
end
