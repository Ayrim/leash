class CreateUserGroupRelations < ActiveRecord::Migration
  def change
    create_table :user_group_relations do |t|
      t.integer :group
      t.references :user, index: true, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
