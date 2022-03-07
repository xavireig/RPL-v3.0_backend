# frozen_string_literal: true

require 'test_helper'
class LeagueCreateTest
  describe '#Create' do
    it 'creates a League' do
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

      result = Api::V1::League::Create.call(
        starting_round: 1,
        required_teams: 8,
        match_numbers: 24,
        season_id: new_season.id,
        user_id: current_user.id,
        invite_code: 'HelloWorld123',
        league_type: 'private',
        title: 'FC Legends Best'
      )

      league = result['model']
      league.persisted?.must_equal true
      assert_equal league.user_id, current_user.id
      league.title.must_equal 'FC Legends Best'
    end
  end
end
