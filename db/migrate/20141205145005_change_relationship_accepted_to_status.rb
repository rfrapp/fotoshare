class ChangeRelationshipAcceptedToStatus < ActiveRecord::Migration
  def change
  	rename_column :relationships, :accepted, :status 
  	change_column :relationships, :status, :string 
  end
end
