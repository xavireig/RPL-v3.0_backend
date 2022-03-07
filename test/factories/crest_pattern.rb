# frozen_string_literal: true

FactoryBot.define do
  factory :crest_pattern do
    name Faker::Name.name
    crest_shape_id Faker::Number.between(1, 10)
    svg_uid Faker::Lorem.characters(10)
  end
end
