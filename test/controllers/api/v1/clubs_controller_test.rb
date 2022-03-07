# frozen_string_literal: true

require 'test_helper'
class ClubsControllerTest < ActionController::TestCase
  tests Api::V1::ClubsController
  include FactoryBot::Syntax::Methods

  setup do
    @season = create(:season)
    @crest_shape = create(:crest_shape)
    @crest_pattern = create(:crest_pattern, crest_shape_id: @crest_shape.id)
    @user = create(:user)
    @virtual_club1 =
      create(
        :virtual_club,
        user_id: @user.id,
        crest_pattern_id: @crest_pattern.id
      )
    @virtual_club2 =
      create(
        :virtual_club,
        user_id: @user.id,
        crest_pattern_id: @crest_pattern.id
      )
    @virtual_club3 =
      create(
        :virtual_club,
        user_id: @user.id,
        crest_pattern_id: @crest_pattern.id
      )
  end

  test '#Index' do
    get :index, params: { auth_token: @user.authentication_token }
    assert_response :success
    assert_includes @response.body, @virtual_club1.name
  end

  test '#Create_success' do
    post :create, params:
    {
      club:
        {
          name: Faker::Name.name,
          color1: Faker::Name.last_name,
          color2: Faker::Name.last_name,
          color3: Faker::Name.last_name,
          user_id: @user.id,
          crest_pattern_id: @crest_pattern.id
        },
      auth_token: @user.authentication_token
    }

    assert_response :success
    assert_includes @response.body, @user.id.to_s
  end

  test '#Create_fail due to not providing user auth token' do
    post :create, params: {
      club: {
        name: Faker::Name.name,
        color1: Faker::Name.last_name,
        color2: Faker::Name.last_name,
        color3: Faker::Name.last_name,
        crest_pattern_id: @crest_pattern.id
      }
    }
    assert_includes @response.body, '404'
  end

  test '#Show' do
    get :show, params: {
      id: @virtual_club2.id,
      auth_token: @user.authentication_token
    }

    assert_response :success
    assert_includes @response.body, @virtual_club2.color1

    get :show, params: {
      id: @virtual_club2.id + @virtual_club1.id + @virtual_club3.id,
      auth_token: @user.authentication_token
    }
    assert_includes @response.body, 'Club not found'
  end

  test '#Update' do
    put :update, params: {
      id: @virtual_club3.id,
      club:
        {
          name: @virtual_club3.name,
          abbr: 'Hello'
        },
      auth_token: @user.authentication_token
    }

    assert_response :success
    assert_includes @response.body, 'Hello'

    put :update, params: {
      id: @virtual_club2.id + @virtual_club1.id + @virtual_club3.id,
      club:
        {
          name: Faker::Name.name,
          abbr: Faker::Name.name
        },
      auth_token: @user.authentication_token
    }
    assert_includes @response.body, 'Club not found'
  end
end
