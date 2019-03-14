class Response < ApplicationRecord
  belongs_to :announcement
  belongs_to :user

  validates_presence_of :price
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 10000 }

  enum status: { pending: 0, cancelled: 1, declined: 2, accepted: 3 }
end
