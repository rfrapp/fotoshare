class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.string :reset_digest
      t.boolean :activated, default: false
      t.boolean :admin
      t.datetime :activated_at
      t.datetime :reset_sent_at
      t.datetime :last_login
      
      t.timestamps null: false
    end
  end
end
