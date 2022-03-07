# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Footballer model
  module FootballerAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        navigation_icon 'fa fa-users'
        label_plural 'Footballers'
      end
    end
  end
end
