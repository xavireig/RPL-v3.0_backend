# frozen_string_literal: true


# club representer
class ClubRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :u_id, as: :extid
  property :name
  property :short_club_name
end