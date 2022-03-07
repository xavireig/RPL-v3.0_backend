# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to send a transfer offer to a club
  class Accept < Trailblazer::Operation
    extend Contract::DSL

    step :transfer_offer_exists?
    failure :offer_does_not_exist, fail_fast: true
    step :game_week_exists?
    failure :game_week_does_not_exist, fail_fast: true
    step :fetch_transfer_offer
    step :fetch_sender_virtual_club
    step :fetch_receiver_virtual_club
    step :fetch_game_week
    step :check_receiver_club_capacity
    failure :receiver_club_already_full, fail_fast: true
    step :check_offerer_club_capacity
    failure :offerer_club_already_full, fail_fast: true
    step :check_offerer_club_budget
    failure :not_enough_budget, fail_fast: true
    step :check_offered_footballers
    failure :offered_vf_club_has_changed, fail_fast: true
    step :check_requested_footballers, fail_fast: true
    failure :requested_vf_club_has_changed, fail_fast: true
    step :requested_vfs_fixture_started?
    failure :requested_vfs_fixture_ongoing, fail_fast: true
    step :offered_vfs_fixture_started?
    failure :offered_vfs_fixture_ongoing, fail_fast: true
    step :deduct_offerer_club_budget
    step :add_receiver_club_budget
    step :add_transfer_status_to_requested_vfs
    step :add_transfer_status_to_offered_vfs
    step :find_sender_club_current_gw
    step :find_receiver_club_current_gw
    step :drop_offered_vfs_engagement
    step :drop_requested_vfs_engagement
    step :create_new_offered_vf_engagements
    step :create_new_requested_vf_engagements
    step :create_transfer_activity!
    step :update_transfer_offer_status!
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def transfer_offer_exists?(options, params:, **)
      params[:transfer_offer]
    end

    def offer_does_not_exist(options)
      options['message'] = 'Transfer offer has expired!'
    end

    def game_week_exists?(params:, **)
      params[:game_week]
    end

    def game_week_does_not_exist(options)
      options['message'] = 'Current round has not been opened
        yet for transfer to happen. Please wait!'
    end

    def fetch_transfer_offer(options, params:, **)
      options['transfer_offer'] = params[:transfer_offer]
    end

    def fetch_sender_virtual_club(options)
      options['sender_vc'] = options['transfer_offer'].sender_virtual_club
    end

    def fetch_receiver_virtual_club(options)
      options['receiver_vc'] = options['transfer_offer'].receiver_virtual_club
    end

    def fetch_game_week(options, params:, **)
      options['game_week'] = params[:game_week]
    end

    def check_receiver_club_capacity(options)
      options['receiver_vc'].current_game_week.virtual_engagements.count -
        options['transfer_offer'].requested_virtual_footballers.count +
        options['transfer_offer'].offered_virtual_footballers.count <=
        options['receiver_vc'].league.squad_size
    end

    def receiver_club_already_full(options)
      options['message'] =
        'Accepting this bid would put you over your league\'s squad limit.
          Please drop a player from your line up!'
    end

    def check_offerer_club_capacity(options)
      options['sender_vc'].current_game_week.virtual_engagements.count -
        options['transfer_offer'].offered_virtual_footballers.count +
        options['transfer_offer'].requested_virtual_footballers.count <=
        options['sender_vc'].league.squad_size
    end

    def offerer_club_already_full(options)
      options['message'] =
        'Whoops! Accepting this bid would put the bid sender over their
          league\'s squad limit!'
    end

    def check_offerer_club_budget(options)
      if options['sender_vc'].budget < options['transfer_offer'].amount
        false
      else
        true
      end
    end

    def not_enough_budget(options)
      options['message'] = 'Bid sender does not have enough budget!'
    end

    def check_offered_footballers(options)
      options['transfer_offer'].offered_virtual_footballers.each do |vf|
        if vf.virtual_club.id == options['sender_vc'].id && !vf.transferred
          true
        else
          return false
        end
      end
    end

    def offered_vf_club_has_changed(options)
      options['message'] = 'Offered footballers does not belong to
        the bid sender club anymore!'
    end

    def check_requested_footballers(options)
      options['transfer_offer'].requested_virtual_footballers.each do |vf|
        if vf.virtual_club.id == options['receiver_vc'].id && !vf.transferred
          true
        else
          return false
        end
      end
    end

    def requested_vf_club_has_changed(options)
      options['message'] = 'Your club does not have the requested
        footballers anymore!'
    end

    def requested_vfs_fixture_started?(options)
      options['transfer_offer'].requested_virtual_footballers.each do |r_vf|
        return false if r_vf.footballer.current_fixture.now_play || r_vf.footballer.current_fixture.done?
      end
      true
    end

    def requested_vfs_fixture_ongoing(options)
      options['message'] = 'One or more requested
        footballer\'s fixture has started! Try accepting this offer in the next game week.'
    end

    def offered_vfs_fixture_started?(options)
      options['transfer_offer'].offered_virtual_footballers.each do |o_vf|
        return false if o_vf.footballer.current_fixture.now_play || o_vf.footballer.current_fixture.done?
      end
      true
    end

    def offered_vfs_fixture_ongoing(options)
      options['message'] = 'One or more offered
        footballer\'s fixture has started! Try accepting this offer in the next game week.'
    end

    def deduct_offerer_club_budget(options)
      options['transfer_offer'].sender_virtual_club.budget -=
          options['transfer_offer'].amount
      options['transfer_offer'].sender_virtual_club.save
    end

    def add_receiver_club_budget(options)
      options['transfer_offer'].receiver_virtual_club.budget +=
          options['transfer_offer'].amount
      options['transfer_offer'].receiver_virtual_club.save
    end

    def add_transfer_status_to_requested_vfs(options)
      options['transfer_offer'].
        requested_virtual_footballers.update_all(transferred: true)
      options['transfer_offer'].
        requested_virtual_footballers.update_all(virtual_club_id: options['sender_vc'].id)
    end

    def add_transfer_status_to_offered_vfs(options)
      options['transfer_offer'].
        offered_virtual_footballers.update_all(transferred: true)
      options['transfer_offer'].
        offered_virtual_footballers.update_all(virtual_club_id: options['receiver_vc'].id)
    end

    def find_sender_club_current_gw(options)
      options['sender_gw'] = options['sender_vc'].current_game_week
    end

    def find_receiver_club_current_gw(options)
      options['receiver_gw'] = options['receiver_vc'].current_game_week
    end

    def drop_offered_vfs_engagement(options)
      offered_virtual_engagements =
        VirtualEngagement.where(
          game_week: options['sender_gw'],
          virtual_footballer: options['transfer_offer'].offered_virtual_footballers
        )
      offered_virtual_engagements.each do |ve|
        game_week_ids = GameWeek.tree_for(ve.game_week.previous_game_week).pluck(:id)
        VirtualEngagement.where(
          game_week_id: game_week_ids,
          virtual_footballer_id: ve.virtual_footballer.id
        ).destroy_all
      end
    end

    def drop_requested_vfs_engagement(options)
      requested_virtual_engagements =
        VirtualEngagement.where(
          game_week: options['receiver_gw'],
          virtual_footballer: options['transfer_offer'].requested_virtual_footballers
        )
      requested_virtual_engagements.each do |ve|
        game_week_ids = GameWeek.tree_for(ve.game_week.previous_game_week).pluck(:id)
        VirtualEngagement.where(
          game_week_id: game_week_ids,
          virtual_footballer_id: ve.virtual_footballer.id
        ).destroy_all
      end
    end

    def create_new_offered_vf_engagements(options)
      receiver_vc_game_week_ids =
        GameWeek.tree_for(options['receiver_gw'].previous_game_week).pluck(:id)
      receiver_vc_game_week_ids.each do |rvc_gw|
        options['transfer_offer'].offered_virtual_footballers.each do |o_vf|
          VirtualEngagement.create(
            game_week_id: rvc_gw,
            virtual_footballer_id: o_vf.id,
            status: 0
          )
        end
      end
    end

    def create_new_requested_vf_engagements(options)
      sender_vc_game_week_ids =
        GameWeek.tree_for(options['sender_gw'].previous_game_week).pluck(:id)
      sender_vc_game_week_ids.each do |svc_gw|
        options['transfer_offer'].requested_virtual_footballers.each do |r_vf|
          VirtualEngagement.create(
            game_week_id: svc_gw,
            virtual_footballer_id: r_vf.id,
            status: 0
          )
        end
      end

    end

    def create_transfer_activity!(options)
      options['transfer_offer'].requested_virtual_footballers.each do |r_vf|
        ::TransferActivity::Create.call(
          league_id: options['sender_vc'].league.id,
          from_virtual_club_id: options['receiver_vc'].id,
          to_virtual_club_id: options['sender_vc'].id,
          virtual_footballer_id: r_vf.id,
          amount: options['transfer_offer'].amount,
          auction: false,
          virtual_round_id: options['receiver_vc'].league.running_virtual_round.id
        )
      end
      options['transfer_offer'].offered_virtual_footballers.each do |o_vf|
        ::TransferActivity::Create.call(
          league_id: options['receiver_vc'].league.id,
          from_virtual_club_id: options['sender_vc'].id,
          to_virtual_club_id: options['receiver_vc'].id,
          virtual_footballer_id: o_vf.id,
          amount: options['transfer_offer'].amount,
          auction: false,
          virtual_round_id: options['sender_vc'].league.running_virtual_round.id
        )
      end
    end

    def update_transfer_offer_status!(options)
      options['transfer_offer'].status = 2
      options['transfer_offer'].save
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['receiver_vc'].league_id,
          recipient_id: options['sender_vc'].user_id,
          sender_id: options['receiver_vc'].user_id,
          activity_type: Notification::ActivityTypes::ACCEPT,
          object_type: options['transfer_offer'].class,
          object_id: options['transfer_offer'].id,
          content: "#{options['receiver_vc'].name} has accepted your transfer bid",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Transfer Rejected Notification. Please try again!'
    end
  end
end
