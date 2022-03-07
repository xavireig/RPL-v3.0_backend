# frozen_string_literal: true
require 'rpl_logger'

# to select a random footballer
class DraftHistory
  # to auto pick virtual footballer
  class AutoPick < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::DraftHistory, :find_by)
    step :find_league
    step :find_virtual_club
    step :find_available_footballer
    step :pick!

    private

    def find_league(options)
      RplLogger.drafting_log(options['model'].league_id, "===== AUTO PICK STARTING ========")
      RplLogger.drafting_log(options['model'].league_id, "DraftHistory id: #{options['model'].id}")
      RplLogger.drafting_log(options['model'].league_id, "League id: #{options['model'].league_id}")
      options['league'] = options['model'].league
    end

    def find_virtual_club(options)
      RplLogger.drafting_log(options['model'].league_id, "VirtualClub id: #{options['model'].virtual_club_id}")
      options['vc'] = options['model'].virtual_club
    end

    def find_available_footballer(options)
      first_pf =
        options['vc'].preferred_footballers.order(position: :asc).first
      if first_pf.present?
        options['vf'] = first_pf.virtual_footballer
      else
        v_footballers =
          options['league'].virtual_footballers.includes(:footballer).where.not(footballers: {current_club_id: 62}).available.
            order('footballers.rank')
        options['vf'] =
          pick_footballer(options['vc'], v_footballers)
      end
    end

    def pick!(options)
      RplLogger.drafting_log(options['model'].league_id, "picking footballer #{options['vf'].id}")

      ::DraftHistory::Pick.call(
        id: options['model'].id,
        virtual_footballer_id: options['vf'].id
      )
      RplLogger.drafting_log(options['model'].league_id, "===== AUTO PICK ENDING ========")
    end

    def take(virtual_club, v_footballer)
      RplLogger.drafting_log(virtual_club.league_id, "passing virtual_club is #{virtual_club.id}")
      RplLogger.drafting_log(virtual_club.league_id, "passing virtual_footballer is #{v_footballer.id}")
      f_position =
        v_footballer.footballer.position

      # check empty position for this footballer
      f_number_range =
        f_position_num_range_for(f_position)

      f_count_by_position =
        club_footballers_data(virtual_club)[f_position]

      if f_count_by_position < f_number_range[:min]
        v_footballer
      elsif f_count_by_position < f_number_range[:max]
        min_req_fill?(virtual_club, f_position) && v_footballer
      else
        # false means need to check next footballer
        false
      end
    end

    # data for ex_type already checked so,
    # don't need to check again
    def min_req_fill?(v_club, ex_type)
      @_min_req ||= (Footballer.types - [ex_type]).select do |type|
        club_footballers_data(v_club)[type] <
          f_position_num_range_for(type)[:min]
      end.size.zero?
    end

    # count of footballer with type for this virtual club
    def club_footballers_data(virtual_club)
      @_data ||=
        virtual_club.count_footballers_by_type
    end

    def f_position_num_range_for(type_name)
      case type_name
      when 'Forward' then { min: 3, max: 4 }
      when 'Midfielder' then { min: 5, max: 7 }
      when 'Defender' then { min: 5, max: 7 }
      when 'Goalkeeper' then { min: 1, max: 2 }
      else {}
      end
    end

    def pick_footballer(v_club, v_footballers)
      RplLogger.drafting_log(v_club.league_id, "passing v_club is #{v_club.id}")
      prefered_v_f = nil

      v_footballers.each do |v_footballer|
        prefered_v_f =
          take(v_club, v_footballer)
        if prefered_v_f.instance_of?(VirtualFootballer)
          break
        end
      end

      prefered_v_f
    end
  end
end
