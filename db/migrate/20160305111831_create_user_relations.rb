class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.integer :user_1_id, index: true
      t.integer :user_2_id, index: true
      t.string :name
      t.date :start_date
      t.boolean :is_pending, default: true

      t.timestamps null: false
    end
  end
end
