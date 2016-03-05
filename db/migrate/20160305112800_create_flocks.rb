class CreateFlocks < ActiveRecord::Migration
  def change
    create_table :flocks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :flock, index: true, foreign_key: true
      t.references :animal, index: true, foreign_key: true
      t.references :planning, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
