# frozen_string_literal: true

require 'test_helper'
class LeaguesControllerTest < ActionController::TestCase
  tests Api::V1::LeaguesController
  include FactoryBot::Syntax::Methods

  setup do
    @season = create(:season)
    @user = create(:user)
    @league = create(:league, user: @user, season: @season)
  end

  test '#index' do
    get :index, params: { auth_token: @user.authentication_token }
    assert_response :success
    assert_includes @response.body, @league.title
  end

  test '#show' do
    get :show, params: {
      id: @league.id,
      auth_token: @user.authentication_token
    }

    assert_response :success
    assert_includes @response.body, @league.title

    get :show, params: {
      id: 9999,
      auth_token: @user.authentication_token
    }
    assert_includes @response.body, 'League is not found'
  end

  test '#create_success' do
    post :create, params:
      {
        league: attributes_for(:league, :category),
        auth_token: @user.authentication_token
      }

    assert_response :success
    assert_includes @response.body, @user.id.to_s
  end

  test '#create_fail due to not providing user auth token' do
    post :create, params: {
      league: attributes_for(:league, :category)
    }
    assert_includes @response.body, '404'
  end
end
