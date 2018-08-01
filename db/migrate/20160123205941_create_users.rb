class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.string :firstname,          null: false
    	t.string :lastname
    	t.string :email,              null: false
      t.string :crypted_password,   null: false
      t.string :salt,               null: false
    	t.string :language
    	t.string :nationality
    	t.date :birthdate
    	t.string :phone
  		t.string :activation_digest
  		t.boolean :activated,		       default: false
  		t.datetime :activated_at
  		t.string :reset_digest
  		t.datetime :reset_sent_at
  		t.string :description
  		t.string :profile_picture
  		t.string :banner_picture
  		t.integer :number_of_walks
  		t.string :walking_region
  		t.string :skills
  		t.boolean :is_premium,		     default: false
  		t.string :pricing
  		t.boolean :professional,	     default: false
  		t.boolean :is_walker
  		t.references :preference,	     index: true, foreign_key: true
  		t.references :experience, 	     index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
