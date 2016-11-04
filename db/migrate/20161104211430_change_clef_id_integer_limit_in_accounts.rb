class ChangeClefIdIntegerLimitInAccounts < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :clef_id, :integer, limit: 10
  end
end
