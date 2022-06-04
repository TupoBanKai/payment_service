class Transaction < ApplicationRecord
  belongs_to :client
  belongs_to :product

  scope :active, -> { where.not(order_id: nil).where(status: 'New') }
end
