# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Invitation model
  module InvitationAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Invitation'
        navigation_icon 'fa fa-handshake-o'
        label_plural 'Invitations'
      end
    end
  end
end
