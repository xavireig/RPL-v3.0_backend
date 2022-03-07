# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Club model
  module ManagerAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        label_plural 'Managers'
      end
    end
  end
end
