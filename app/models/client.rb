class Client < ApplicationRecord
  has_many :transactions
  has_many :products, through: :transaction

  validates :username, :password, presence: true
end
