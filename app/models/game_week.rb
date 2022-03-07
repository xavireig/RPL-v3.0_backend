# frozen_string_literal: true

# game week model
class GameWeek < ApplicationRecord
  delegate :league, to: :virtual_club
  delegate :round, to: :virtual_round
  #
  # associations
  #

  belongs_to :virtual_round
  belongs_to :virtual_club
  belongs_to :formation
  has_one :round, through: :virtual_round
  has_many :fixtures, through: :round
  has_many :virtual_engagements, dependent: :destroy
  has_many :virtual_footballers,
    through: :virtual_engagements
  has_one :next_game_week, class_name: 'GameWeek', foreign_key: :parent_id, dependent: :destroy
  belongs_to :previous_game_week, class_name: 'GameWeek', foreign_key: :parent_id
  #
  # instance methods
  #

  def starting_xi_v_footballers
    vf_by_status(VirtualEngagement.statuses[:starting_xi])
  end

  def reserved_v_footballers
    vf_by_status(VirtualEngagement.statuses[:reserved])
  end

  def benched_v_footballers
    vf_by_status(VirtualEngagement.statuses[:benched])
  end

  def v_gk_on_benched
    benched_v_footballers.includes(:footballer).
      where(footballers: { position: 'Goalkeeper' })
  end

  def v_gk_on_reserved
    reserved_v_footballers.includes(:footballer).
      where(footballers: { position: 'Goalkeeper' })
  end

  def non_v_gk_on_reserved
    reserved_v_footballers.includes(:footballer).
      where.not(footballers: { position: 'Goalkeeper' })
  end

  def forward_footballers
    vf_by_position('Forward')
  end

  def midfielder_footballers
    vf_by_position('Midfielder')
  end

  def defender_footballers
    vf_by_position('Defender')
  end

  def goal_keeper_footballers
    vf_by_position('Goalkeeper')
  end

  def score
    players = self.auto_sub_on ? profitable_players : virtual_engagements.starting_xi
    if league.scoring_type.eql?'point'
      players.map(&:calculated_statistic).sum
    else
      result =
        players.each_with_object(Hash.new(0)) do |ve, memo|
          ve.calculated_statistic.each do |key, value|
            memo[key] += value
          end
        end

      result = calculate_pass_percentage(result)
      # calculate_saves_percentage(result)
    end
  end

  # define some dynamic methods
  # example for forward_in_reserved
  Footballer::TYPES.product(VirtualEngagement.statuses.keys).each do |attrs|
    define_method("#{attrs.first.downcase}_in_#{attrs.last}") do
      vf_by_position_and_status(attrs.first, attrs.last)
    end
  end

  private

  def vf_by_position_and_status(position, status)
    vf_by_status(status).includes(:footballer).
      where(
        footballers: { position: position }
      )
  end

  def vf_by_position(position)
    virtual_footballers.includes(:footballer).
      where(footballers: { position: position })
  end

  def vf_by_status(status)
    virtual_footballers.includes(:virtual_engagements).
      where(virtual_engagements: { status: status })
  end

  def calculate_pass_percentage(result)
    return result unless result.kind_of?(Hash)

    # remove unwanted keys
    total_pass = result.delete('total_pass').to_f
    accurate_pass = result.delete('accurate_pass').to_f

    if result.key?('pass_percent')
      result['pass_percent'] =
        total_pass.zero? ? accurate_pass : accurate_pass / total_pass
    end

    result
  end

  # def calculate_saves_percentage(result)
  #   return result unless result.kind_of?(Hash)
  #
  #   # remove unwanted keys
  #   saves = result.delete('saves_percent_saves').to_f
  #   goals_conceded = result.delete('saves_percent_goals_conceded').to_f
  #
  #   if result.key?('saves_percent')
  #     result['saves_percent'] =
  #       goals_conceded.zero? ? saves : saves / goals_conceded
  #   end
  #
  #   result
  # end

  def profitable_players
    virtual_engagements.starting_xi.map do |footballer|
      footballer.update_attribute(:subbed_id, nil)
      if !footballer.statistic.nil?
        footballer.statistic.mins_played.zero? ? pick_from_bench(footballer) : footballer
      elsif footballer.statistic.nil?
        pick_from_bench(footballer)
      end
    end
  end

  def pick_from_bench(player)
    player_with_rank = {
      player: nil,
      rank: 99999
    }

    virtual_engagements.benched.each do |bench|
      if !bench.statistic.nil? && bench.footballer.position == player.footballer.position &&
          bench.statistic.mins_played > 0 &&
          bench.footballer.rank < player_with_rank[:rank] &&
          virtual_engagements.starting_xi.select{|footballer| footballer.subbed_id == bench.id}.empty?

        player_with_rank[:player] = bench
        player_with_rank[:rank] = bench.footballer.rank
      end
    end

    if player_with_rank[:player].nil?
      return player
    else
      player.update_attribute(:subbed_id, player_with_rank[:player].id)
      return player_with_rank[:player]
    end
  end
end
