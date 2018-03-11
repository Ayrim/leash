class CreateVisibilities < ActiveRecord::Migration[5.1]
  def change
    create_table :visibilities do |t|
      t.string :value

      t.timestamps null: false
    end
  end
end
