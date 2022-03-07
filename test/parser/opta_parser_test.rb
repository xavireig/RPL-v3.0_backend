# frozen_string_literal: true

require 'test_helper'

describe OptaParser do
  describe 'squad file' do
    it 'checks if squad file is parsed correctly' do
      squad_path = Rails.root.join('test', 'files', 'srml-8-2016-squads.xml')
      OptaParser::XmlParser.new(squad_path, 'srml-8-2016-squads.xml').parse
      Footballer.count.must_equal 2
      Engagement.count.must_equal 2
      Club.count.must_equal 2
    end

    it 'checks if new squad file updates existing footballer attributes' do
      squad_path = Rails.root.join('test', 'files', 'srml-8-2014-squads.xml')
      OptaParser::XmlParser.new(squad_path, 'srml-8-2014-squads.xml').parse
      test_footballer = Footballer.find_by_name('Glen Kamara')
      test_footballer.original_u_id.must_equal 'p153134'
      target_value =
        Engagement.where(footballer_id: test_footballer.id).first.leave_date
      assert_nil target_value

      squad_path = Rails.root.join('test', 'files', 'srml-8-2015-squads.xml')
      OptaParser::XmlParser.new(squad_path, 'srml-8-2015-squads.xml').parse
      target_value =
        Engagement.where(footballer_id: test_footballer.id).
          last.leave_date.present?
      assert target_value
    end
  end

  describe 'result file' do
    it 'checks if total number of fixtures' do
      Season.create(u_id: 2016, name: 'Season 2016/2017')
      create(:club, u_id: 35, original_u_id: 't35')
      create(:club, u_id: 88, original_u_id: 't88')
      create(:club, u_id: 13, original_u_id: 't13')
      create(:club, u_id: 8, original_u_id: 't8')

      result_path = Rails.root.join('test', 'files', 'srml-8-2016-results.xml')
      OptaParser::XmlParser.new(result_path, 'srml-8-2016-results.xml').parse
      season = Season.find_by_name('Season 2016/2017')
      Fixture.where(season_id: season.id).count.must_equal 2
    end
  end

  describe 'squad, results, match results' do
    it 'checks if dependency of 3 opta files is maintained' do
      squad_path = Rails.root.join('test', 'files', 'srml-8-2016-squads.xml')
      OptaParser::XmlParser.new(squad_path, 'srml-8-2016-squads.xml').parse

      Footballer.count.must_equal 2
      Engagement.count.must_equal 2
      Club.count.must_equal 2

      test_footballer1 = Footballer.find_by_name('Riyad Mahrez')
      assert test_footballer1.present?
      test_footballer2 = Footballer.find_by_name('Greg Luer')
      assert test_footballer2.present?

      result_path = Rails.root.join('test', 'files', 'srml-8-2016-results.xml')
      OptaParser::XmlParser.new(result_path, 'srml-8-2016-results.xml').parse

      Fixture.count.must_equal 1
      fixture = Fixture.where(original_u_id: 'g855178').first
      assert fixture.present?

      match_results_name = 'srml-8-2016-f855178-matchresults.xml'
      match_results_path = Rails.root.join('test', 'files', match_results_name)
      OptaParser::XmlParser.new(match_results_path, match_results_name).parse

      Statistic.count.must_equal 2
      stats = Statistic.where(
        fixture_id: fixture.id,
        footballer_id: test_footballer1.id
      )
      assert stats.present?
    end
  end
end
