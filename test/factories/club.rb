# frozen_string_literal: true

FactoryBot.define do
  factory :club do
    name Faker::Name.name
    city Faker::Address.city
    short_club_name Faker::Name.name
    abbreviation Faker::Cat.name
    region_name Faker::Address.street_address
    street Faker::Address.street_name
    web_address Faker::Internet.url
    postal_code Faker::Address.postcode
    founded Faker::Number.number(4)
    official_club_name Faker::Name.name
  end
end
