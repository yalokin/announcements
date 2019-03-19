# frozen_string_literal: true

FactoryBot.define do
  factory :announcement do
    user
    description { Faker::Lorem.sentence }
    status { :active }
  end
end