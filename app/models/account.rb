class Account < ApplicationRecord
  validates :public_key, allow_blank: true, uniqueness: true,
            length: { minimum: 26, maximum: 35 }
  has_many :connections

  def self.find_or_create_from_wallet_address(public_key)
    if account = Account.find_by(public_key: public_key)
      return account
    else
      Account.create(public_key: public_key)
    end
  end
end
