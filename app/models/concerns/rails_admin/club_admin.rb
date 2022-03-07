# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Club model
  module ClubAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        navigation_icon 'fa fa-shield'
        label_plural 'Clubs'
      end
    end
  end
end
