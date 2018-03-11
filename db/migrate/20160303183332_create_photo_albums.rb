class CreatePhotoAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :photo_albums do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
	    t.string :description
      t.references :visibility, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
