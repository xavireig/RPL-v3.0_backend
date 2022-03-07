# frozen_string_literal: true

class PreferredFootballer < ApplicationRecord
  # update operation for virtual club which inherits show operation
  class Create < Trailblazer::Operation
    require "reform/form/validation/unique_validator"
    extend Contract::DSL

    contract do
      property :virtual_footballer_id
      property :virtual_club_id
      validates :virtual_footballer_id, presence: true
      validates :virtual_club_id, presence: true
      validates :virtual_footballer_id,
        unique: { scope: [:virtual_club_id], message: 'Player already queued!' }
      validate :available_for_draft

      def available_for_draft
        vc = VirtualClub.includes(:league).find virtual_club_id
        dh = vc.league.draft_histories.where(virtual_footballer_id: virtual_footballer_id)
        if dh.present?
          errors.add :virtual_footballer_id, 'Player already drafted!'
        end
      end
    end

    step Model(::PreferredFootballer, :new)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
