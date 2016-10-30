class Provider < ApplicationRecord
  validates :name, presence: true, uniqueness: true,
            length: { minimum: 4, maximum: 35 }
  validates :api_key, presence: true, uniqueness: true
end
