class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.date :start_date

      t.timestamps null: false
    end
  end
end
