# frozen_string_literal: true

class League < ApplicationRecord
  # to join league
  class Join < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :league_id
      property :current_user
      validates :id, presence: true
      validates :league_id, presence: true
    end

    step :find_league
    step :find_virtual_club
    step :update_invitation!
    success :fetch_available_league
    step :connect_club_with_league!
    step :insert_club_in_draft_order!
    step :broadcast_draft_order

    private

    def find_league(options, params:, **)
      league = League.find(params[:league_id])
      if league.blank?
        options['message'] = 'The league is not found'
        false
      else
        options['league'] = league
      end
    end


    def find_virtual_club(options, params:, **)
      user_club = VirtualClub.find(params[:id])
      if user_club.present?
        options['user_club'] = user_club
      else
        options['message'] = 'Club not found'
        false
      end
    end

    def fetch_available_league(options, params:, **)
      league = options['league']
      while(league.virtual_clubs.count >= league.required_teams)
        league = league.sub_league
        league ||= clone_league(options, params)
        options['league'] = league
      end
    end

    def clone_league(options, params)
      result = {}
      League.transaction do
        h = {}
        h[:parent_league_id] = options['league'].id
        h[:chairman_id] = params[:current_user].id
        result = League::Clone.call(h)
        options['user_club'].league_id = result['model'].id
        options['user_club'].save!
      end
      result['model']
    end

    def connect_club_with_league!(options)
      league = options['league']
      user_club = options['user_club']
      user_club.league_id = league.id
      user_club.save
    rescue ActiveRecord::RecordNotUnique
      options['message'] =
        'Ooops! Looks like you already have a club in this league.
          Please join a different league!'
      false
    else
      options['model'] = user_club
    end

    def update_invitation!(options, params:, **)
      invite =
        Invitation.where(
          league_id: options['league'].id,
          email: params[:current_user].email,
          status: 'waiting'
        ).first
      unless invite.nil?
        invite.status = 'accepted'
        invite.save
      end
      true
    end

    def insert_club_in_draft_order!(options)
      draft_order = options['league'].draft_order
      draft_order.queue.push(options['model'].id) unless
        draft_order.queue.include?(options['model'].id)
      draft_order.save
    end

    def broadcast_draft_order(options)
      ::DraftOrder::Broadcast.call(id: options['league'].id)
    end
  end
end
