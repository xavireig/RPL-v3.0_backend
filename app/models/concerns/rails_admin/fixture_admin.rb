# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Fixture model
  module FixtureAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        navigation_icon 'fa fa-futbol-o'
        label_plural 'Fixtures'
      end
    end
  end
end
