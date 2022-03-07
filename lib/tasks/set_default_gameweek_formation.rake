# frozen_string_literal: true

task set_default_gameweek_formation: :environment do
  leagues = League.all
  leagues.each do |league|
    league.virtual_clubs.each do |virtual_clubs|
      virtual_clubs.game_weeks.each do |game_week|
        game_week.formation = league.allowed_formations.first
        game_week.save
      end
    end
  end
end
