# frozen_string_literal: true

class VirtualEngagement < ApplicationRecord
  # delete footballer from virtual club's line up
  class Destroy < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::VirtualEngagement, :find_by)
    failure :virtual_engagement_not_found, fail_fast: true
    step :ve_round
    step :current_round_number
    step :dropping_from_current_round?
    failure :cannot_drop, fail_fast: true
    step :retrieve_game_week
    step :footballer_fixture_started?
    failure :footballer_fixture_ongoing, fail_fast: true
    step :change_waiver_status
    step :delete_virtual_engagement!
    step :delete_next_round_virtual_engagement!
    step :create_auction!
    failure :already_dropped_once, fail_fast: true
    step :create_transfer_activity!
    failure :cannot_drop, fail_fast: true

    private

    def virtual_engagement_not_found(options, params:, **)
      options['message'] = "Footballer with #{params[:id]} not found!"
    end

    def ve_round(options)
      options['ve_round'] = options['model'].game_week.virtual_round.round.number
    end

    def current_round_number(options)
      options['current_round'] = Season.current_season.running_round.number
    end

    def dropping_from_current_round?(options)
      if options['ve_round'].eql? options['current_round']
        true
      else
        false
      end
    end

    def cannot_drop(options)
      options['message'] = 'You can only drop players from current round!'
    end

    def retrieve_game_week(options)
      options['game_week'] = options['model'].game_week
      options['formation'] = options['model'].game_week.formation
    end

    def footballer_fixture_started?(options)
      vf_current_fixture =
        options['model'].virtual_footballer.footballer.current_fixture
      if vf_current_fixture.nil? # footballer is out of EPL. Thus, allowing user to drop
        true
      elsif vf_current_fixture.now_play || vf_current_fixture.done?
        false
      else
        true
      end
    end

    def footballer_fixture_ongoing(options)
      options['message'] =
        'You cannot drop player after their fixture has started!'
    end

    def delete_virtual_engagement!(options)
      options['model'].destroy

      ::GameWeek::SyncLineupWithFormation.call(
        id: options['game_week'].id,
        new_formation: options['formation'].name
      )
    end

    def delete_next_round_virtual_engagement!(options)
      game_week_ids = GameWeek.tree_for(options['game_week']).pluck(:id)
      VirtualEngagement.where(
        game_week_id: game_week_ids,
        virtual_footballer_id: options['model'].virtual_footballer.id
      ).destroy_all

      ::GameWeek::ChangeFormation.call(
        id: options['game_week'].id,
        new_formation: options['formation'].name
      )
    end

    def change_waiver_status(options, params:, **)
      options['model'].virtual_footballer.waiver = true
      options['model'].virtual_footballer.virtual_club_id = nil
      options['model'].virtual_footballer.save
    end

    def create_auction!(options, params:, **)
      if params[:waiver]
        begin
          options['model'].virtual_footballer.auctions.create(
            virtual_round: options['model'].game_week.virtual_round
          )
        rescue ActiveRecord::RecordNotUnique
          false
        end
      else
        true
      end
    end

    def already_dropped_once(options)
      options['message'] = 'You have already dropped the player!'
    end

    def create_transfer_activity!(options)
      ::TransferActivity::Create.call(
        league_id: options['model'].virtual_club.league.id,
        from_virtual_club_id: options['model'].virtual_club.id,
        to_virtual_club_id: nil,
        virtual_footballer_id: options['model'].virtual_footballer.id,
        amount: 0,
        auction: false,
        virtual_round_id: options['model'].game_week.virtual_round.id
      )
    end
  end
end
