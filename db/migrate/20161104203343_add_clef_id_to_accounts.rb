class AddClefIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :clef_id, :integer
  end
end
