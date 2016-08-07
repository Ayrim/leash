class AlterTags < ActiveRecord::Migration
  def change
    add_reference :tags, :created_by, references: :user
    add_reference :tags, :user
    add_reference :tags, :animal
    add_reference :tags, :activity
    add_reference :tags, :route
    add_reference :tags, :blog
  end
end
