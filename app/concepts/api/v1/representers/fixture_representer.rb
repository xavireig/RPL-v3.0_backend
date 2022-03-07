# frozen_string_literal: true

# fixture representer
class FixtureRepresenter < Representable::Decorator
  include Representable::JSON
  delegate :home_score, :away_score, :match_time, :now_play,
    :done?, :away_club, :home_club, :ongoing?, to: 'represented'
  property :id
  property :u_id, as: :fixture_id
  property :done?, as: :is_done, exec_context: :decorator
  property :home_score, exec_context: :decorator
  property :away_score, exec_context: :decorator
  property :period, as: :ext_match_status
  property :now_play, exec_context: :decorator
  property :date, as: :scheduled
  property :home_match,
    getter: ->(represented:, **) {
      if represented.current_club&.id.eql?(represented.home_club_id)
        true
      else
        false
      end
    }
  property :opponent_team_data,
    getter: ->(represented:, **) {
      if represented.current_club&.id.eql?(represented.home_club_id)
        represented.away_club
      else
        represented.home_club
      end
    },
    decorator: ClubRepresenter
    property :ongoing?, as: :is_ongoing, exec_context: :decorator
end
