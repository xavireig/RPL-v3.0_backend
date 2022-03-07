# frozen_string_literal: true

class VirtualEngagement < ApplicationRecord
  # delete footballer from virtual club's line up
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :game_week_id
      property :virtual_footballer_id
      property :virtual_footballer_engagement_id
      validates :id, presence: true
      validates :game_week_id, presence: true
      validates :virtual_footballer_id, presence: true
    end

    step Model(::VirtualClub, :find_by)
    failure :virtual_club_not_found, fail_fast: true
    step :check_club_budget
    step :not_enough_budget, fail_fast: true
    step :check_current_gw_club_capacity
    failure :current_gw_club_is_full, fail_fast: true
    step :check_if_vf_exists
    failure :vf_does_not_exist, fail_fast: true
    step :vf_fixture_started?
    failure :footballer_fixture_ongoing, fail_fast: true
    step :check_vf_virtual_club
    failure :footballer_already_taken, fail_fast: true
    step :delete_virtual_engagement
    failure :could_not_drop_player, fail_fast: true
    step :fetch_game_week
    step :assign_virtual_club!
    step :add_player_to_current_gw
    # Uncommenting this will affect all next game week's line up
    # step :add_player_to_next_gws
    step :deduct_club_transfer_budget!
    step :create_transfer_activity!

    private

    def virtual_club_not_found(options)
      options['message'] = 'Club does not exist'
    end

    def check_club_budget(options)
      if options['model'].budget >= 1
        true
      else
        false
      end
    end

    def not_enough_budget(options)
      options['message'] =
        'Adding free agents deduct 1 million from your transfer budget.
        Looks like you don\'t have enough budget to add this player.'
    end

    def delete_virtual_engagement(options, params:, **)
      return true if params[:virtual_footballer_engagement_id].blank?
      result = ::VirtualEngagement::Destroy.
        call(id: params[:virtual_footballer_engagement_id], waiver: true)
      if result.success?
        true
      else
        options['drop_error'] = result['message']
        false
      end
    end

    def could_not_drop_player(options)
      options['message'] = options['drop_error']
    end

    def fetch_game_week(options, params:, **)
      options['game_week'] = GameWeek.find(params[:game_week_id])
      options['formation'] = options['game_week'].formation
    end

    def check_current_gw_club_capacity(options, params:, **)
      drop_count = params[:virtual_footballer_engagement_id].blank? ? 0 : 1
      if options['model'].current_game_week.virtual_footballers.count -
          drop_count < options['model'].league.squad_size
        true
      else
        false
      end
    end

    def current_gw_club_is_full(options)
      options['message'] = 'Looks like your club capacity is full!
        Please drop some players and try again.'
    end

    def check_if_vf_exists(options, params:, **)
      options['vf'] = VirtualFootballer.find(params[:virtual_footballer_id])
    rescue ActiveRecord::RecordNotFound
      options['message'] = 'Could not find footballer!'
      false
    end

    def vf_does_not_exist(options)
      options['message'] = 'Could not find footballer!'
    end

    def vf_fixture_started?(options)
      vf_current_fixture = options['vf'].footballer.current_fixture
      if vf_current_fixture.now_play || vf_current_fixture.done? || options['vf'].waiver
        false
      else
        true
      end
    end

    def footballer_fixture_ongoing(options)
      options['message'] =
        'Player is not a free agent anymore and has been put on waiver!'
    end

    def check_vf_virtual_club(options, params:, **)
      if options['vf'].virtual_club.present?
        options['message'] = 'Footballer is not a free agent anymore!'
        false
      else
        true
      end
    end

    def footballer_already_taken(options)
      options['message'] = 'Footballer is not a free agent anymore!'
    end

    def assign_virtual_club!(options, params:, **)
      options['vf'].update_attribute(:virtual_club_id, params[:id])
    end

    def add_player_to_current_gw(options, params:, **)
      VirtualEngagement.create(
        game_week_id: options['game_week'].id,
        virtual_footballer_id: params[:virtual_footballer_id],
        status: 0
      )

      ::GameWeek::SyncLineupWithFormation.call(
        id: options['game_week'].id,
        new_formation: options['formation'].name
      )
    end

    def add_player_to_next_gws(options, params:, **)
      game_week_ids = GameWeek.tree_for(options['game_week']).pluck(:id)
      game_week_ids.each do |gw|
        VirtualEngagement.create(
          game_week_id: gw,
          virtual_footballer_id: params[:virtual_footballer_id],
          status: 0
        )
      end
    end

    def deduct_club_transfer_budget!(options)
      options['model'].budget -= 1
      options['model'].save
    end

    def create_transfer_activity!(options)
      ::TransferActivity::Create.call(
        league_id: options['model'].league.id,
        from_virtual_club_id: nil,
        to_virtual_club_id: options['model'].id,
        virtual_footballer_id: options['vf'].id,
        amount: 1,
        auction: false,
        virtual_round_id: options['model'].league.running_virtual_round.id
      )
    end
  end
end
