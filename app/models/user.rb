class User < ApplicationRecord
  has_many :announcements, dependent: :destroy
  has_many :responses, dependent: :destroy
end
