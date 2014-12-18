class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.text :caption
      t.string :location
      t.references :album, index: true
      t.boolean :public, default: true

      t.timestamps null: false
    end
    add_foreign_key :pictures, :albums
    add_index :pictures, [:album_id, :created_at]
  end
end
