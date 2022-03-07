# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Message model
  module MessageAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Message'
        navigation_icon 'fa fa-envelope-open'
        label_plural 'Messages'
      end
    end
  end
end
