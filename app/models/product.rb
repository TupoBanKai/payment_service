class Product < ApplicationRecord
  has_many :clients, through: :transactions
  has_many :transactions

  validates :name, :amount, presence: true
end
