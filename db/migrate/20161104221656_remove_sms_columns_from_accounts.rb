class RemoveSmsColumnsFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :mobile_number
    remove_column :accounts, :verification_code
    remove_column :accounts, :is_verified
  end
end
