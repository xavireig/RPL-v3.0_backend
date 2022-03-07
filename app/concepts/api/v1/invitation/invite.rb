# frozen_string_literal: true

module Api
  module V1
    module Invitation
      # invite users to join league
      class Invite < ::Invitation::Invite
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::Invitation do
            property :id
            property :email
            property :status
            property :league_id
          end
        end
      end
    end
  end
end
