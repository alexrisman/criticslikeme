class RemoveDetailsFromUser < ActiveRecord::Migration
	def change
	  	remove_column :users, :last_company_name_1
	    remove_column :users, :last_title_1
	    remove_column :users, :last_industry_1
	    remove_column :users, :last_location_1
	    remove_column :users, :last_company_name_2
	    remove_column :users, :last_title_2
	    remove_column :users, :last_industry_2
	    remove_column :users, :last_location_2
	    remove_column :users, :last_company_name_3
	    remove_column :users, :last_title_3
	    remove_column :users, :last_industry_3
	    remove_column :users, :last_location_3
	    remove_column :users, :school_1
	    remove_column :users, :school_2
	    remove_column :users, :school_3
	    remove_column :users, :company_name
	end
end
