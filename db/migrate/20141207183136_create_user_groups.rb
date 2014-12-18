class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :user_groups, [:user_id, :created_at]
  end
end
