class CreateWallposts < ActiveRecord::Migration[5.1]
  def change
    create_table :wallposts do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :picture
      t.references :blog, index: true, foreign_key: true
      t.integer :route
      t.integer :tag
      t.string :url
      t.string :message

      t.timestamps null: false
    end
  end
end
