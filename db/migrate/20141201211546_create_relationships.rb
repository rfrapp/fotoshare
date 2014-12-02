class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :other_user_id
      t.string :type
      t.boolean :accepted

      t.timestamps
    end
  end
end
