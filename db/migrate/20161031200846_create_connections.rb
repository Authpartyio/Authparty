class CreateConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.belongs_to :account, index: true
      t.string :provider_id
      t.datetime :connected_on
      t.string :bearer
      t.timestamps
    end
  end
end
