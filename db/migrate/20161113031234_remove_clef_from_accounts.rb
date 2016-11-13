class RemoveClefFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :clef_id
  end
end
