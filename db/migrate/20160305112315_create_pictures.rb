class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :comment
      t.integer :tag
      t.string :url
  	  t.references :photo_album, 		index: true, foreign_key: true
  	  t.references :visibility, 		index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
