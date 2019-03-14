class Announcement < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy

  validates :description, presence: true, length: { maximum: 1000 }

  enum status: { active: 0, cancelled: 1, closed: 2 }
end
