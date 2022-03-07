# frozen_string_literal: true

module Api
  module V1
    module DraftHistory
      # to show individual draft order of a league
      class Index < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::DraftHistory do
            property :iteration, as: :iter
            property :step
            property :virtual_club_id, as: :club_id
            property :virtual_footballer_id, as: :footballer_id
            # property :in_team
            property :virtual_footballer, as: :footballer do
              property :id
              property :full_name, exec_context: :decorator
              property :position, exec_context: :decorator
              # property :club_id, as: :real_team_id, exec_context: :decorator
              property :club, as: :real_team, exec_context: :decorator do
                property :id
                property :u_id, as: :extid
                property :name
                property :short_club_name
              end
              # property :injury_status
              # property :last_news_date

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
end
