class Account < ApplicationRecord
  validates :public_key, presence: true, uniqueness: true,
            length: { minimum: 26, maximum: 35 }
  validates :mobile_number, phone: { possible: false, allow_blank: false, types: [:mobile] }
end
