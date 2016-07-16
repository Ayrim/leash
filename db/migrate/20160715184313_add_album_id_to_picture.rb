class AddAlbumIdToPicture < ActiveRecord::Migration
  def change
    add_reference :pictures, :photoalbum, index: true, foreign_key: true
  end
end
