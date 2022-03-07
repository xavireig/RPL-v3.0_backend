# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    fname Faker::Name.first_name
    lname Faker::Name.last_name
    password Faker::Internet.password(8)
    email Faker::Internet.email
    confirmed_at Faker::Date.backward(1)
    authentication_token Faker::Vehicle.vin
    provider 'base'
  end
end
