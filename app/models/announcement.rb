# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy

  validates :description, presence: true, length: { maximum: 1000 }

  enum status: { active: 0, cancelled: 1, closed: 2 }

  def cancel!
    transaction do
      update(status: :cancelled)
      responses.update_all(status: :declined)
    end
  end
end
