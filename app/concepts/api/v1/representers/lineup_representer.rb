# frozen_string_literal: true
require_relative 'statistic_representer'

# lineup representer
class LineupRepresenter < Representable::Decorator
  include Representable::JSON
  delegate :id, :footballer_id, :round, :footballer, to: 'represented.virtual_footballer'

  property :id
  property :starting_xi?, as: :on_starting_xi
  property :benched?, as: :on_bench
  property :reserved?, as: :on_reserve
  property :block_for_action, exec_context: :decorator
  property :calculated_statistic, as: :points
  nested :footballer_role_in_round do
    property :game_role
  end

  property :subbed_out, exec_context: :decorator
  property :subbed_in, exec_context: :decorator

  def subbed_in
    !represented.subbed_with.nil?
  end

  def subbed_out
    !represented.subbed_by.nil?
  end

  property :fixture,
    as: :match_data,
    render_filter: ->(input, represented:, **) {
    return input unless input

    input.current_club =
     represented.virtual_footballer.footballer.club(represented.round)
    input
    },
    decorator: FixtureRepresenter

  property :footballer,
     render_filter: ->(input, represented:, **) {
       return input unless input

       input.current_club =
           represented.virtual_footballer.footballer.club(represented.round)
       input
     },
    exec_context: :decorator,
    decorator: FootballerRepresenter

  property :statistic,
    as: :footballer_stat_in_round,
    decorator: StatisticRepresenter

  def footballer_id
    represented.footballer.id
  end

  def block_for_action
    false
  end
end