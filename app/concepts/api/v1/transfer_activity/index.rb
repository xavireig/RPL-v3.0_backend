# frozen_string_literal: true

module Api
  module V1
    module TransferActivity
      # gets league's transfer activity
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::TransferActivity do
            property :from_virtual_club, as: :club_from, render_nil: true do
              property :id
              property :name
              property :budget
              property :abbr
            end
            property :to_virtual_club, as: :club_to, render_nil: true do
              property :id
              property :name
              property :budget
              property :abbr
            end
            property :amount, as: :money_offered
            property :created_at, as: :get_date
            property :status
            property :auction, as: :is_auction
            property :footballer, exec_context: :decorator do
              property :id
              property :name, as: :full_name
              property :position
              property :current_club, as: :real_team do
                property :id
                property :name
                property :short_club_name
              end
            end

            def footballer
              represented.virtual_footballer.footballer
            end
          end
        end
      end
    end
  end
end
