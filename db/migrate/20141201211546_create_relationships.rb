class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :status
      t.references :user
      t.references :other_user
      t.references :group
      
      t.timestamps null: false
    end
  end
end
