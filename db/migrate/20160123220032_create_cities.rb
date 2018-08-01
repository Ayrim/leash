class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :postalcode

      t.timestamps null: false
    end
  end
end
