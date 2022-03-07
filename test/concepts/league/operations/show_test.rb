# frozen_string_literal: true

require 'test_helper'
class LeagueShowTest
  describe '#Show' do
    it 'shows a league' do
      new_season = Season.create(
        u_id: 12,
        name: 'Season 999'
      )

      current_user = User.create!(
        email: 'rahber.alam@bdipo.com',
        password: 'nascenia',
        fname: 'Raafa',
        lname: 'Alam',
        provider: 'base',
        confirmed_at: '2017-04-27 19:27:05.512000'
      )

      create_result = Api::V1::League::Create.call(
        starting_round: 1,
        required_teams: 8,
        match_numbers: 24,
        season_id: new_season.id,
        user_id: current_user.id,
        league_type: 'public',
        invite_code: 'HelloWorld123',
        title: 'FC Legends Best'
      )

      league = create_result['model']

      show_result = Api::V1::League::Show.call(
        id: league.id
      )

      show_result.success?.must_equal true
      shown_league = show_result['model']
      shown_league.persisted?.must_equal true
      assert_equal league.id, shown_league.id
      shown_league.title.must_equal 'FC Legends Best'
    end
  end
end
