class AddApiSecretToProvidersTable < ActiveRecord::Migration[5.0]
  def change
    add_column :providers, :api_secret, :string
  end
end
