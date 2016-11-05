class AddLoggedOutColumnToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :logged_out_at, :datetime
  end
end
