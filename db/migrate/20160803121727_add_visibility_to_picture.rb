class AddVisibilityToPicture < ActiveRecord::Migration
  def change
    add_reference :pictures, :visibility, index: true, foreign_key: true
  end
end
