# frozen_string_literal: true

# virtual club representer
class VirtualClubRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :stadium, render_nil: true
  property :motto, render_nil: true
  property :abbr, render_nil: true
  property :color1
  property :color2
  property :color3
  property :league_id, render_nil: true
  property :league,
           decorator: LeagueRepresenter
  property :user_id
  property :user do
    property :id
    property :fname, as: :full_name
    property :lname
    property :email, render_nil: true
    property :is_email_confirmed, exec_context: :decorator

    def is_email_confirmed
      true
    end
  end
  property :crest_pattern_id
  property :crest_pattern do
    property :id
    property :name
    property :crest_shape_id
    property :svg_url
  end
  property :budget
  # property :season_id
  property :rank, as: :place
  property :total_pts, as: :pts
  property :form_str, exec_context: :decorator

  def form_str
    represented.form.last(5).join('-')
  end
end
