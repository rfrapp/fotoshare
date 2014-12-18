class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.datetime :last_upload
      t.references :user, index: true
      
      t.timestamps null: false
    end
    add_index :albums, [:user_id, :created_at]
  end
end
