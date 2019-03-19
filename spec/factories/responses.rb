# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    user
    price { 1500 }
    status { :pending }
  end
end