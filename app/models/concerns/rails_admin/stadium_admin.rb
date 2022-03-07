# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Club model
  module StadiumAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        label_plural 'Stadia'
      end
    end
  end
end
