# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Club model
  module FixturesMatchOfficialAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        label_plural 'Fixtures Match Officials'
      end
    end
  end
end
