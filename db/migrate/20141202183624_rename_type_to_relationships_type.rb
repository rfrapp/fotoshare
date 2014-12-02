class RenameTypeToRelationshipsType < ActiveRecord::Migration
  def change
  	rename_column :relationships, :type, :relationship_type 
  end
end
