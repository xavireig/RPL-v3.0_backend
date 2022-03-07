# frozen_string_literal: true

# footballer representer
class FootballerRepresenter < Representable::Decorator
  include Representable::JSON
  delegate :name, :current_club, :jersey_num, to: 'represented'

  property :id
  property :u_id, as: :extid
  property :name, as: :full_name, exec_context: :decorator
  property :first_name, as: :fname
  property :last_name, as: :lname

  property :position, exec_context: :decorator
  def position
    represented.position.downcase
  end
  property :rank
  property :jersey_num, exec_context: :decorator
  property :club_id, as: :real_team_id, exec_context: :decorator

  def club_id
    represented.reload if  represented.current_club.nil?
    represented.current_club.id
  end
  property :current_club,
    as: :real_team,
    exec_context: :decorator, decorator: ClubRepresenter
end