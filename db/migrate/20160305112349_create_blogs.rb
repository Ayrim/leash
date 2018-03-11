class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :content
      t.integer :tag

      t.timestamps null: false
    end
  end
end
