# frozen_string_literal: true

module Api
  module V1
    module VirtualClub
      # api response using representer for showing virtual club without standing calculation
      class Info < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
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
        end
      end
    end
  end
end
