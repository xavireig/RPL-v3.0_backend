# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for User model
  module UserAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'User'
        navigation_icon 'fa fa-user-secret'
        label_plural 'Users'
      end
    end
  end
end
