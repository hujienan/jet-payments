class Payment < ApplicationRecord
  # Active record validation for payment
  validates :card_number, presence: true, length: { is: 16 }
  validates :expiry_date, presence: true, length: { is: 4 }
  validates :email_address, format: { with: /\A(.+)@(.+)\z/, message: "Email invalid"  }, length: { minimum: 4, maximum: 254 }
  # validates :email_address, email: true, length: { maximum: 100 }
  validates :name_on_card, :billing_address, presence: true, length: { maximum: 200 }
end
