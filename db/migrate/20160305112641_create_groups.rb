class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :desription
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
