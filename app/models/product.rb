class Product < ApplicationRecord
  has_many :transactions
  has_many :clients, through: :transactions

  validates :name, :amount, presence: true
end
