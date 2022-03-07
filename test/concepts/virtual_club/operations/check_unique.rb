# frozen_string_literal: true

require 'test_helper'
class VirtualClubCheckUniqueTest
  describe '#CheckUnique' do
    it 'checks a virtual club\'s name is unique for a user this season' do
      crest_shape = CrestShape.create!(name: 'Lava', svg_uid: 'adasaa')
      crest_pattern = CrestPattern.create!(
        name: 'Hello',
        crest_shape_id: crest_shape.id,
        svg_uid: '334fs'
      )
      current_user = User.create!(
        email: 'rahber.alam@bdipo.com',
        password: 'nascenia',
        fname: 'Raafa',
        lname: 'Alam',
        provider: 'base',
        confirmed_at: '2017-04-27 19:27:05.512000'
      )

      Api::V1::VirtualClub::Create.call(
        name: 'FC banani',
        crest_pattern_id: crest_pattern.id,
        user_id: current_user.id,
        color1: 'blue',
        color2: 'red',
        color3: 'white',
        abbr: 'FCB',
        motto: 'I love Football!'
      )

      check_unique_result = Api::V1::VirtualClub::CheckUnique.call(
        club_name: 'FC Banani'
      )

      check_unique_result.result?.must_equal false
    end
  end
end
