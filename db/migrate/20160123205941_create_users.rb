class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :firstname,        :null => false
    	t.string :lastname
    	t.string :email,            :null => false
        t.string :crypted_password, :null => false
        t.string :salt,             :null => false
    	t.string :language
    	t.string :nationality
    	t.date :birthdate
    	t.string :phone

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
