class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.boolean :user_defined, null: false, default: false
      t.references :created_by, references: :user
      t.references :user
      t.references :animal
      t.references :activity
      t.references :route
      t.references :blog

      t.timestamps null: false
    end
  end
end
