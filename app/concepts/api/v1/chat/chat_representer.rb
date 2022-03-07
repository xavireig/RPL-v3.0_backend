# frozen_string_literal: true

# to show chat
class ChatRepresenter < Representable::Decorator
  include Representable::JSON

  property :content
  property :virtual_club, as: :club do
    property :name
    property :crest_pattern_id
    property :crest_pattern do
      property :id
      property :svg_url
      property :crest_shape_id
    end
  end
  property :created_at
end
