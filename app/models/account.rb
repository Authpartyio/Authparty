class Account < ApplicationRecord
  validates :public_key, allow_blank: true, uniqueness: true,
            length: { minimum: 26, maximum: 35 }
  has_many :connections

  def self.find_or_create_from_auth_hash(auth_hash)
    if account = Account.find_by(clef_id: auth_hash[:uid])
      return account
    else
      Account.create(clef_id: auth_hash[:uid])
    end
  end
end
