class AddDescriptionToPhotoalbum < ActiveRecord::Migration
  def change
    add_column :photoalbums, :description, :string
  end
end
