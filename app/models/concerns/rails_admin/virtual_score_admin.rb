# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Fixture model
  module VirtualScoreAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        label_plural 'Virtual scores'
        list do
          configure :home_virtual_club do
            queryable true
            searchable [:name]
          end
          configure :away_virtual_club do
            searchable [:name]
            queryable true
          end
          field :id
          field :virtual_fixture
          field :home_score
          field :away_score
          field :home_virtual_club
          field :away_virtual_club
          include_all_fields
        end
        edit do
          field :virtual_fixture do
            read_only true
            inline_edit false
          end
          field :home_score
          field :away_score
          field :home_virtual_club do
            read_only true
          end
          field :away_virtual_club do
            read_only true
          end
        end
      end
    end
  end
end
