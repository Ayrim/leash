class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :numberAddition
      t.references :user, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
