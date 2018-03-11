class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.references :user, index: true, foreign_key: true
      t.string :access_token
      t.timestamp :expires_at

      t.timestamps null: false
    end
  end
end
