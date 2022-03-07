# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    name Faker::Name.first_name
    u_id Faker::Number.unique.number(4)
  end
end
