class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.references :animal, index: true, foreign_key: true
      t.string :breed
      t.integer :maximum_walking_time
      t.string :remarks
      t.boolean :other_dogs
      t.boolean :cats
      t.boolean :children

      t.timestamps null: false
    end
  end
end
