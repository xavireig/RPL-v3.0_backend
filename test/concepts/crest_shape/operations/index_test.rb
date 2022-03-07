# frozen_string_literal: true

require 'test_helper'
class CrestShapeIndexTest
  describe '#Index' do
    it 'displays all crest shapes with corresponding patterns' do
      crest_shape1 = create(:crest_shape)
      crest_shape2 = create(:crest_shape)

      create(:crest_pattern, crest_shape_id: crest_shape1.id)
      create(:crest_pattern, crest_shape_id: crest_shape1.id)
      create(:crest_pattern, crest_shape_id: crest_shape2.id)

      crest_shapes = ::CrestShape.all

      representer = 'representer.render.class'
      response =
        Api::V1::CrestShape::Index.call[representer].new(crest_shapes)
      parsed_response = JSON.parse(response.to_json)

      parsed_response[0]['id'].must_equal crest_shape1.id
      parsed_response[0]['crest_patterns'].length.must_equal 2
    end
  end
end
