class Transaction < ApplicationRecord
  belonds_to :client
  belongs_to :product

  scope :active, -> { where(type: "New" && order_id != null) }
end
