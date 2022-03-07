# frozen_string_literal: true

FactoryBot.define do
  factory :virtual_club do
    name Faker::Name.name
    color1 Faker::Name.last_name
    color2 Faker::Name.last_name
    color3 Faker::Name.last_name
  end
end
