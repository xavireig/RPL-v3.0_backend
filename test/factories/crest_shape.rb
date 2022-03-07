# frozen_string_literal: true

FactoryBot.define do
  factory :crest_shape do
    name Faker::Name.name
    svg_uid Faker::Lorem.characters(10)
  end
end
