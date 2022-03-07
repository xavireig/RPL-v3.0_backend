# frozen_string_literal: true

FactoryBot.define do
  factory :footballer do
    first_name Faker::Name.first_name
    middle_name Faker::Name.first_name
    last_name Faker::Name.last_name
    name Faker::Name.name
    known_name Faker::Name.last_name
    display_name Faker::Name.last_name
    birth_date Faker::Date.birthday(21, 35)
    birth_place Faker::Address.country
    first_nationality Faker::Address.country
    preferred_foot 'left'
    weight Faker::Number.between(70, 90)
    height Faker::Number.between(160, 180)
    country Faker::Address.country
    position 'Forward'
  end
end
