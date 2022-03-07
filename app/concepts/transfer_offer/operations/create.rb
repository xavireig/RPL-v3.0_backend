# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to send a transfer offer to a club
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :sender_virtual_club_id
      property :receiver_virtual_club_id
      property :offered_virtual_footballer_ids
      property :requested_virtual_footballer_ids
      property :amount
      property :message
      validates :sender_virtual_club_id, presence: true
      validates :receiver_virtual_club_id, presence: true
      validates :requested_virtual_footballer_ids, presence: true
      validates :amount, presence: true
    end

    step :check_if_current_round
    failure :not_current_round, fail_fast: true
    step :find_sender_virtual_club
    failure :sender_virtual_club_not_found, fail_fast: true
    step :check_sender_club_budget
    failure :not_enough_budget, fail_fast: true
    step :find_receiver_virtual_club
    failure :receiver_virtual_club_not_found, fail_fast: true
    step :check_requested_footballer
    failure :not_enough_requested_footballer, fail_fast: true
    step :check_sender_club_capacity
    failure :sender_club_capacity_full, fail_fast: true
    step :check_receiver_club_capacity
    failure :receiver_club_capacity_full, fail_fast: true
    step Model(::TransferOffer, :new)
    failure :could_not_create_transfer_offer, fail_fast: true
    step :create_requested_vfs
    step :create_offered_vfs
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
    failure :could_not_create_transfer_offer, fail_fast: true
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def check_if_current_round(options, params:, **)
      params[:round].present?
    end

    def not_current_round(options)
      options['message'] = 'Transfer is closed until next round is opened!'
    end

    def find_sender_virtual_club(options, params:, **)
      options['sender_vc'] = VirtualClub.find(params[:sender_virtual_club_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def sender_virtual_club_not_found(options)
      options['message'] = 'Bid sender club not found!'
    end

    def check_sender_club_budget(options, params:, **)
      if options['sender_vc'].budget < params[:amount]
        false
      else
        true
      end
    end

    def not_enough_budget(options)
      options['message'] =
        'Oops! Looks like you don\'t have enough budget to add this player.'
    end

    def find_receiver_virtual_club(options, params:, **)
      options['receiver_vc'] = VirtualClub.find(params[:receiver_virtual_club_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def receiver_virtual_club_not_found(options)
      options['message'] = 'Bid receiver club not found!'
    end

    def check_requested_footballer(options, params:, **)
      params[:requested_virtual_footballer_engagement_ids].present? ||
        params[:requested_virtual_footballer_id].present?
    end

    def not_enough_requested_footballer(options)
      options['message'] =
        'Please request at least one footballer to send a transfer offer'
    end

    def check_sender_club_capacity(options, params:, **)
      if params[:requested_virtual_footballer_id].present?
        options['sender_vc'].current_game_week.virtual_footballers.count -
          params[:offered_virtual_footballer_engagement_ids].length +
          (params[:requested_virtual_footballer_engagement_ids].length + 1) <= options['sender_vc'].league.squad_size
      else
        options['sender_vc'].current_game_week.virtual_footballers.count -
          params[:offered_virtual_footballer_engagement_ids].length +
          params[:requested_virtual_footballer_engagement_ids].length <= options['sender_vc'].league.squad_size
      end
    end

    def sender_club_capacity_full(options)
      options['message'] = 'This bid would put you over your
        league\'s squad limit.'
    end

    def check_receiver_club_capacity(options, params:, **)
      if params[:requested_virtual_footballer_id].present?
        options['receiver_vc'].current_game_week.virtual_footballers.count -
          (params[:requested_virtual_footballer_engagement_ids].length + 1) +
          params[:offered_virtual_footballer_engagement_ids].length <= options['receiver_vc'].league.squad_size
      else
        options['receiver_vc'].current_game_week.virtual_footballers.count -
          params[:requested_virtual_footballer_engagement_ids].length +
          params[:offered_virtual_footballer_engagement_ids].length <= options['receiver_vc'].league.squad_size
      end
    end

    def receiver_club_capacity_full(options)
      options['message'] = 'This bid would put your opponent over their
        league\'s squad limit.'
    end

    def could_not_create_transfer_offer(options)
      options['message'] = 'Failed to send transfer bid. Please try again!'
    end

    def create_requested_vfs(options, params:, **)
      params[:requested_virtual_footballer_ids] =
        VirtualFootballer.includes(:virtual_engagements).
        where(
          virtual_engagements: {
            id: params[:requested_virtual_footballer_engagement_ids]
          }
        ).pluck(:id)
      params[:requested_virtual_footballer_ids].push(params[:requested_virtual_footballer_id]) || true
    end

    def create_offered_vfs(options, params:, **)
      params[:offered_virtual_footballer_ids] =
        VirtualFootballer.includes(:virtual_engagements).
        where(
          virtual_engagements: {
            id: params[:offered_virtual_footballer_engagement_ids]
          }
        ).pluck(:id)
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['receiver_vc'].league_id,
          recipient_id: options['receiver_vc'].user_id,
          sender_id: options['sender_vc'].user_id,
          activity_type: Notification::ActivityTypes::CREATE,
          object_type: options['model'].class,
          object_id: options['model'].id,
          content: "#{options['sender_vc'].name} has sent you a transfer bid",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create New Transfer Notification. Please try again!'
    end
  end
end
