# frozen_string_literal: true

class League < ApplicationRecord
  # to remove virtual club from league
  class Detach < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :league_id
      property :current_user
      validates :id, presence: true
      validates :league_id, presence: true
    end

    step :find_league
    failure :league_not_found, fail_fast: true
    step :draft_running?
    failure :draft_already_started, fail_fast: true
    step Model(::VirtualClub, :find_by)
    failure :virtual_club_not_found, fail_fast: true
    step :chairman?
    failure :cannot_remove_chairman, fail_fast: true
    step :remove_vc_from_league!
    step :remove_vc_from_draft_order!
    step :broadcast_draft_order

    private

    def find_league(options, params:, **)
      options['league'] = League.find(params[:league_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def draft_running?(options)
      !%w[running processing].freeze.include?(options['league'].draft_status)
    end

    def draft_already_started(options)
      options['message'] =
        'You cannot drop players after draft has been started!'
    end

    def virtual_club_not_found(options)
      options['message'] = 'Club not found!'
    end

    def chairman?(options)
      !options['model'].user.eql?(options['league'].user)
    end

    def cannot_remove_chairman(options)
      options['message'] =
        'You cannot remove yourself since you are the league chairman!'
    end

    def remove_vc_from_league!(options)
      options['model'].league = nil
      options['model'].save
    end

    def remove_vc_from_draft_order!(options)
      draft_order = options['league'].draft_order
      draft_order.queue.delete(options['model'].id)
      draft_order.save
    end

    def broadcast_draft_order(options)
      ::DraftOrder::Broadcast.call(id: options['league'].id)
    end
  end
end
