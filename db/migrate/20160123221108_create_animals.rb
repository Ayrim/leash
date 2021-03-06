class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :name
      t.date :birthdate
      t.string :breed
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
