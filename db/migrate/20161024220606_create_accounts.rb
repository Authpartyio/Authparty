class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :public_key
      t.string :mobile_number
      t.string :verification_code
      t.boolean :is_verified

      t.timestamps
    end
  end
end
