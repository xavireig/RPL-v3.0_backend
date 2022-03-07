# frozen_string_literal: true

class GameWeek < ApplicationRecord
  # changes formation of all game weeks
  class ChangeFormation < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :new_formation
      validates :id, presence: true
      validates :new_formation, presence: true
    end

    step Model(::GameWeek, :find_by)
    failure :game_week_not_found, fail_fast: true
    step :update_game_week_formation!
    step :parse_formation
    step :perform_format
    success :update_bench_reserved
    success :update_next_game_week_formation!

    private

    def game_week_not_found(options)
      options['message'] = 'Game Week not found!'
    end

    def update_game_week_formation!(options, params:, **)
      league_formation =
        options['model'].virtual_club.league.allowed_formations.
          where(name: params[:new_formation]).first
      options['model'].formation = league_formation
      options['model'].save
    end

    def parse_formation(options, params:, **)
      format = params[:new_formation].gsub(/\D/, '')
      formation = {
        forward: format[2].to_i,
        midfielder: format[1].to_i,
        defender: format[0].to_i,
        goalkeeper: 1
      }
      options['format'] = formation
    end

    def perform_format(options)
      format = options['format']
      # reload game_week every time,
      # so that we get updated data
      format_fwd(options['model'].reload, format)
      format_def(options['model'].reload, format)
      format_mid(options['model'].reload, format)
      format_gk(options['model'].reload, format)
      options['model']
    end

    def update_next_game_week_formation!(options)
      game_week = options['model']
      if game_week.next_game_week.present?
        ::ChangeFormationWorker.perform_async(
          game_week.next_game_week.id,
          game_week.formation.name
        )
      end
    end
    # forward will be like { defender: 4, forward: 2, midfilder: 4 }
    # work flow:
    # 1. check existing footballers in starting_xi,
    # 2. if new format need more f of any type
    #  ---- add extra footballers to starting_xi
    # 3. else
    #    ---- remove extra footballer from starting_xi
    # 4. update bench and reserved section

    # ==== FORMAT FORWARD  ====
    def format_fwd(game_week, format)
      fwd_v_footballers =
        game_week.forward_in_starting_xi

      # check target format size
      if format[:forward] > fwd_v_footballers.count
        add_forward_to_xi(
          game_week,
          format[:forward] - fwd_v_footballers.count
        )
      else
        remove_vf_from_xi(
          game_week,
          game_week.forward_in_starting_xi,
          fwd_v_footballers.count - format[:forward]
        )
      end
    end

    def add_forward_to_xi(game_week, num_extra_forward)
      target_v_footballers =
        take(game_week.forward_in_benched, num_extra_forward, game_week.round)

      # bench does not enough footballer
      if target_v_footballers.size < num_extra_forward
        target_v_footballers += (
          take(
            game_week.forward_in_reserved,
            num_extra_forward - target_v_footballers.size,
            game_week.round
          )
        )
      end

      # change status of find footballers
      change_status_to(
        VirtualEngagement.statuses[:starting_xi],
        target_v_footballers, game_week
      )
    end

    # ==== FORMAT DEFENDER  ====
    def format_def(game_week, format)
      def_v_footballers =
        game_week.defender_in_starting_xi

      # check target format size
      if format[:defender] > def_v_footballers.count
        add_defender_to_xi(
          game_week,
          format[:defender] - def_v_footballers.count
        )
      else
        remove_vf_from_xi(
          game_week,
          game_week.defender_in_starting_xi,
          def_v_footballers.count - format[:defender]
        )
      end
    end

    def add_defender_to_xi(game_week, num_extra_forward)
      target_v_footballers =
        take(game_week.defender_in_benched, num_extra_forward, game_week.round)

      # bench does not enough footballer
      if target_v_footballers.size < num_extra_forward
        target_v_footballers += (
          take(
            game_week.defender_in_reserved,
            num_extra_forward - target_v_footballers.size,
            game_week.round
          )
        )
      end

      # change status of find footballers
      change_status_to(
        VirtualEngagement.statuses[:starting_xi],
        target_v_footballers, game_week
      )
    end

    # ==== FORMAT MID-FIELDER  ====
    def format_mid(game_week, format)
      mid_v_footballers =
        game_week.midfielder_in_starting_xi

      # check target format size
      if format[:midfielder] > mid_v_footballers.count
        add_midfielder_to_xi(
          game_week,
          format[:midfielder] - mid_v_footballers.count
        )
      else
        remove_vf_from_xi(
          game_week,
          game_week.midfielder_in_starting_xi,
          mid_v_footballers.count - format[:midfielder]
        )
      end
    end

    def add_midfielder_to_xi(game_week, num)
      # need to add footballer for this position
      num_extra_forward = num

      target_v_footballers =
        take(game_week.midfielder_in_benched, num_extra_forward, game_week.round)

      # bench does not enough footballer
      if target_v_footballers.size < num_extra_forward
        target_v_footballers += (
          take(
            game_week.midfielder_in_reserved,
            num_extra_forward - target_v_footballers.size,
            game_week.round
          )
        )
      end

      # change status of find footballers
      change_status_to(
        VirtualEngagement.statuses[:starting_xi],
        target_v_footballers, game_week
      )
    end

    # ==== FORMAT GOALKEEPER  ====
    def format_gk(game_week, format)
      gk_v_footballers =
        game_week.goalkeeper_in_starting_xi

      # check target format size
      if format[:goalkeeper] > gk_v_footballers.count
        add_goalkeeper_to_xi(
          game_week,
          format[:goalkeeper] - gk_v_footballers.count
        )
      else
        remove_vf_from_xi(
          game_week,
          game_week.goalkeeper_in_starting_xi,
          gk_v_footballers.count - format[:goalkeeper]
        )
      end
    end

    def add_goalkeeper_to_xi(game_week, num_extra_forward)
      target_v_footballers =
        take(game_week.goalkeeper_in_benched, num_extra_forward, game_week.round)

      # bench does not enough footballer
      if target_v_footballers.size < num_extra_forward
        target_v_footballers += (
          take(
            game_week.goalkeeper_in_reserved,
            num_extra_forward - target_v_footballers.size,
            game_week.round
          )
        )
      end

      # change status of find footballers
      change_status_to(
        VirtualEngagement.statuses[:starting_xi],
        target_v_footballers, game_week
      )
    end

    # === UPDATE BENCH AND RESERVED FOOTBALLER ===

    def update_bench_reserved(options)
      take_gk_to_benched_from_reserved(
        options['model'].reload
      )

      add_non_gk_f_from_r_2_benched(
        options['model'].reload
      )
    end

    #
    # helper method section
    #

    def take(v_footballers, num, round)
      # sort is desc order
      v_footballers.sort_by(&:rank).select{|v_f| !v_f.fixture_on_round(round).ongoing? }.first(num)
    end

    # remove vf from starting xi because of
    # format changing where num is the number of vf
    # that we need to remove
    def remove_vf_from_xi(game_week, v_footballers, num)
      target_v_footballers =
        v_footballers.sort_by(&:adp).take(num.abs)

      change_status_to(
        VirtualEngagement.statuses[:reserved],
        target_v_footballers,
        game_week
      )
    end

    def change_status_to(status, v_footballers, game_week)
      return if v_footballers.nil? || v_footballers.size.zero?

      VirtualEngagement.where(
        game_week: game_week, virtual_footballer_id: v_footballers.map(&:id)
      ).update_all(status: status)
    end

    def take_gk_to_benched_from_reserved(game_week)
      return unless game_week.v_gk_on_benched.count.zero?

      target_gk =
        game_week.v_gk_on_reserved.sort_by(&:adp).take(1)
      change_status_to(
        VirtualEngagement.statuses[:benched],
        target_gk,
        game_week
      )
    end

    def add_non_gk_f_from_r_2_benched(game_week)
      f_on_benched =
        game_week.benched_v_footballers.count

      return if f_on_benched >= 4

      # max footballer on benched
      num =
        3 - (f_on_benched - game_week.v_gk_on_benched.count)

      target_vfs =
        game_week.non_v_gk_on_reserved.sort_by(&:adp).last(num)

      change_status_to(
        VirtualEngagement.statuses[:benched],
        target_vfs,
        game_week
      )
    end
  end
end
