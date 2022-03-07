# frozen_string_literal: true

# frozen_string_literal: true

task remove_parsing_data: :environment do
  Engagement.delete_all
  Footballer.all.each { |f| f.statistics.destroy_all }
  Statistic.delete_all
  Footballer.delete_all
  Position.delete_all
  FixturesMatchOfficial.destroy_all
  Fixture.delete_all
  Stadium.delete_all
  Round.destroy_all
  Season.all.each { |s| s.clubs.delete_all }
  Club.delete_all
  Season.delete_all
end
