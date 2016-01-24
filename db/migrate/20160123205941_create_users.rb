class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :firstname
    	t.string :lastname
    	t.string :email
    	t.string :password
    	t.string :password_salt
    	t.string :language
    	t.string :nationality
    	t.date :birthdate
    	t.string :phone

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
