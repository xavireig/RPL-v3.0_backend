# frozen_string_literal: true

RailsAdmin.config do |config|
  config.excluded_models =
    %w[ClubsSeason Engagement FixturesMatchOfficial ManagersClub Position Round]
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      only %w[CrestPattern CrestShape]
    end
    export
    show
    edit
    delete
    show_in_app
  end

  config.authorize_with do
    authenticate_or_request_with_http_basic('Login required') do |e, p|
      user = User.find_for_authentication(email: e)
      if user&.valid_password?(p) && user.admin?
        user
      else
        false
      end
    end
  end
end

require 'rails_admin/adapters/active_record'

module RailsAdmin::Adapters::ActiveRecord
  module WhereBuilderExtension
    def initialize(scope)
      @includes = []
      super(scope)
    end

    def add(field, value, operator)
      @includes.push(field.name) if field.association?
      field.searchable_columns.first[:column] = 'away_virtual_clubs_virtual_scores.name' if field.name == :away_virtual_club
      super(field, value, operator)
    end

    def build
      @includes.any? ? super.includes(*(@includes.uniq)) : super
    end
  end

  class WhereBuilder
    prepend WhereBuilderExtension
  end
end
