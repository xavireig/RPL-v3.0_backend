# frozen_string_literal: true

module Api
  module V1
    module PreferredFootballer
      # to show individual draft order of a league
      class Show < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON
          property :id
          property :position
          property :virtual_club_id, as: :club_id
          property :virtual_footballer_id, as: :footballer_id, render_nil: true
          # property :in_team
          property :virtual_footballer, as: :footballer do
            property :id
            property :full_name, exec_context: :decorator
            property :position, exec_context: :decorator
            property :height, exec_context: :decorator
            property :weight, exec_context: :decorator
            property :country, exec_context: :decorator
            property :birth_date, exec_context: :decorator
            property :club, as: :real_team, exec_context: :decorator do
              property :id
              property :u_id, as: :extid
              property :name
              property :short_club_name
            end

            def first_name
              represented.footballer.first_name
            end

            def club_id
              represented.footballer.current_club.id
            end

            def club
              represented.footballer.current_club
            end

            def position
              represented.footballer.position
            end

            def full_name
              represented.footballer.name
            end

            def age
              represented.footballer.age
            end

            def weight
              represented.footballer.weight
            end

            def height
              represented.footballer.height
            end

            def country
              represented.footballer.country
            end

            def birth_date
              represented.footballer.birth_date
            end
          end
          property :virtual_club, as: :club do
            property :id
            property :name
            property :budget
          end
        end
      end
    end
  end
end
