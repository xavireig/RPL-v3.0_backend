# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for League model
  module LeagueAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'League'
        navigation_icon 'fa fa-trophy'
        label_plural 'Leagues'
      end
    end
  end
end
