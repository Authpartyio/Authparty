class CreateProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :api_key
      t.string :callback_url
      t.string :contact_email
      t.string :logo
      t.integer :number_connected

      t.timestamps
    end
  end
end
