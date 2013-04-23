class AddPictureUrlAndFirstNameAndLastNameAndTitleAndIndustryAndLinkedinUrlAndLastCompanyName1AndLastTitle1AndLastIndustry1AndLastLocation1ToUser < ActiveRecord::Migration
  def change
    add_column :users, :picture_url, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :title, :string
    add_column :users, :industry, :string
    add_column :users, :linkedin_url, :string
    add_column :users, :last_company_name_1, :string
    add_column :users, :last_title_1, :string
    add_column :users, :last_industry_1, :string
    add_column :users, :last_location_1, :string
  end
end
