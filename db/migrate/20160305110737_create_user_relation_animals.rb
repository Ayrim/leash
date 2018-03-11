class CreateUserRelationAnimals < ActiveRecord::Migration[5.1]
  def change
    create_table :user_relation_animals do |t|
      t.references :user, index: true, foreign_key: true
      t.references :animal, index: true, foreign_key: true
      t.boolean :is_owner
      t.boolean :can_add_to_flock

      t.timestamps null: false
    end
  end
end
