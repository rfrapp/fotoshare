class ChangeRelationshipTypeToGroupId < ActiveRecord::Migration
  # def change
  # 	rename_column :relationships, :relationship_type, :group_id
  # 	change_column :relationships, :group_id, :integer 
  # end

  def up
  	# execute 'ALTER TABLE relationships ALTER COLUMN relationship_type TYPE integer USING (relationship_type::integer)'
  	# execute 'ALTER TABLE relationships RENAME COLUMN relationship_type TO group_id'
  end 
end
