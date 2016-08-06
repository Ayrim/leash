class AddVisibilityToPhotoalbum < ActiveRecord::Migration
  def change
    add_reference :photoalbums, :visibility, index: true, foreign_key: true
  end
end
