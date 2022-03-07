# frozen_string_literal: true

# generates line up
class League < ApplicationRecord
  # lineup class
  class Lineup < Trailblazer::Operation
    step :find_league
    failure :league_not_found
    step :find_current_season
    step :find_league_last_round
    step :find_rounds
    step :create_virtual_rounds!
    step :create_game_weeks!
    step :create_virtual_engagements!
    step :update_virtual_engagements_status!
    step :create_virtual_fixtures!
    step :update_season_draft_count!
    step :reset_draft_iteration_and_step!


    private

    def find_league(options, params:, **)
      options['league'] = League.find(params[:league_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def find_current_season(options)
      options['current_season'] = Season.current_season
    end

    def find_league_last_round(options)
      options['league_last_round'] =
        options['league'].starting_round + options['league'].match_numbers
    end

    def find_rounds(options)
      starting_round = options['league'].starting_round
      league_last_round = options['league_last_round']
      options['rounds'] =
        options['current_season'].rounds.where(
          number: starting_round...league_last_round
        )
    end

    def create_virtual_rounds!(options)
      VirtualRound.transaction do
        options['rounds'].each do |round|
          VirtualRound.create!(
            league_id: options['league'].id,
            round_id: round.id
          )
        end
      end
    end

    def create_game_weeks!(options)
      league = options['league']
      formation = league.allowed_formations.first
      league.virtual_clubs.each do |virtual_club|
        parent_game_week = nil
        league.virtual_rounds.includes(:round).order('rounds.number asc').each do |virtual_round|
        parent_game_week =
          GameWeek.create!(
            virtual_round_id: virtual_round.id,
            virtual_club_id: virtual_club.id,
            formation: formation,
            parent_id: parent_game_week&.id
          )
        end
      end
    end

    def create_virtual_engagements!(options)
      league = options['league']
      league.draft_histories.includes(virtual_club: [:game_weeks]).each do |dh|
        update_sdp!(dh)
        dh.virtual_club.game_weeks.each do |game_week|
          VirtualEngagement.create!(
            game_week_id: game_week.id,
            virtual_footballer_id: dh.virtual_footballer_id
          )
        end
      end
    end

    def update_virtual_engagements_status!(options)
      virtual_clubs = options['league'].virtual_clubs.reload
      virtual_clubs.each do |virtual_club|
        ::ChangeFormationWorker.perform_in(
          3.seconds, # TODO : remove 3 seconds delay
          virtual_club.first_game_week.id,
          virtual_club.first_game_week.formation.name
        )
      end
    end

    def create_virtual_fixtures!(options)
      league = options['league']
      virtual_clubs = league.virtual_clubs.to_a
      reserve_team = virtual_clubs.pop
      league.virtual_rounds.each do |virtual_round|
        # first match with reserve team
        VirtualFixture.create!(
          virtual_round_id: virtual_round.id,
          home_virtual_club_id: virtual_clubs.first.id,
          away_virtual_club_id: reserve_team.id
        )
        # next match index
        s_index = 1
        e_index = virtual_clubs.size - 1
        until s_index >= e_index
          VirtualFixture.create!(
            virtual_round_id: virtual_round.id,
            home_virtual_club_id: virtual_clubs[s_index].id,
            away_virtual_club_id: virtual_clubs[e_index].id
          )
          s_index += 1
          e_index -= 1
        end
        # shifting
        virtual_clubs.rotate!
      end
    end

    def update_sdp!(draft_history)
      vf = draft_history.virtual_footballer
      ci = draft_history.iteration
      cs = draft_history.step
      sdp = vf.footballer.current_sdp
      sdp.amount += ((ci * draft_history.league.required_teams) + (cs + 1))
      sdp.save
    end

    def update_season_draft_count!(options)
      current_season = options['league'].season
      current_season.draft_count += 1
      current_season.save
    end

    def reset_draft_iteration_and_step!(options)
      options['league'].draft_order.
        update_attributes(current_iteration: 0, current_step: 0)
    end
  end
end
