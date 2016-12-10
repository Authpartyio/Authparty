class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.belongs_to :provider, index: true
      t.string :name
      t.string :description
      t.integer :holders
      t.integer :supply
      t.boolean :locked
      t.timestamps
    end
  end
end
