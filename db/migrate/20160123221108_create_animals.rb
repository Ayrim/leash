class CreateAnimals < ActiveRecord::Migration[5.1]
  def change
    create_table :animals do |t|
      t.string :name
      t.date :birthdate
      t.string :breed
      t.references :user, index: true, foreign_key: true
      t.string :gender
      t.boolean :neutered
      t.string :likes
      t.string :dislikes
      t.string :behaviour
      t.text :description

      t.timestamps null: false
    end
  end
end
