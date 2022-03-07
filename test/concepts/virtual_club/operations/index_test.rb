# frozen_string_literal: true

require 'test_helper'
class VirtualClubIndexTest
  describe '#Index' do
    it 'displays all virtual clubs' do
      @season =  create(:season)
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

      Api::V1::VirtualClub::Create.call(
        name: 'FC Dhanmondi',
        crest_pattern_id: crest_pattern.id,
        user_id: current_user.id,
        color1: 'red',
        color2: 'yellow',
        color3: 'black',
        abbr: 'FCD',
        motto: 'I hate Football!'
      )
      representer = 'representer.render.class'
      virtual_clubs = ::VirtualClub.all
      response =
        Api::V1::VirtualClub::Index.call[representer].new(virtual_clubs)

      parsed_response = JSON.parse(response.to_json)
      parsed_response.length.must_equal 2
      parsed_response[0]['abbr'].must_equal 'FCB'
      parsed_response[1]['motto'].must_equal 'I hate Football!'
    end
  end
end
