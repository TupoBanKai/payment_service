class Client < ApplicationRecord
  has_many :products, through: :transaction
  has_many :transactions

  validates :username, :password, presence: true
end
