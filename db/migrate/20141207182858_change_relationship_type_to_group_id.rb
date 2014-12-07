class ChangeRelationshipTypeToGroupId < ActiveRecord::Migration
  def change
  	rename_column :relationships, :relationship_type, :group_id
  	change_column :relationships, :group_id, :integer 
  end
end
