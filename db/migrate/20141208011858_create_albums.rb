class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id
      t.string :name
      t.datetime :last_upload

      t.timestamps null: false
    end
  end
end
