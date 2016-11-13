class Account < ApplicationRecord
  validates :public_key, presence: true, uniqueness: true,
            length: { minimum: 26, maximum: 35 }
  serialize :providers_authorized, Array
  has_many :connections
end
