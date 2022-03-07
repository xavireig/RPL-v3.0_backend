# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    title 'Test League'
    user
    season
    starting_round 1
    required_teams 12
    match_numbers 38
    sequence(:invite_code)
    league_type 'private'
  end

  trait :category do
    scoring_type 'category'
  end

  trait :point do
    scoring_type 'point'
  end
end
