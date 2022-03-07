# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Club model
  module EngagementAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        label_plural 'Engagements'
      end
    end
  end
end
