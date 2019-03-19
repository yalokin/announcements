# frozen_string_literal: true

class User < ApplicationRecord
  has_many :announcements, dependent: :destroy
  has_many :responses, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end
end
