# frozen_string_literal: true

module Api
  module V1
    module Notification
      # to show individual notification for the user
      class Show < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          property :id
          property :short_description, exec_context: :decorator
          property :status
          property :hidden, exec_context: :decorator

          def short_description
            represented.content
          end

          def hidden
            false
          end

          def transfer_offer
            represented.object_type.constantize.find_by_id(represented.object_id)
          end

          property :transfer_offer,
            if: ->(represented:, **) { represented.object_type == 'TransferOffer' },
            as: :bid, exec_context: :decorator do

            property :id
            property :amount, as: :money_offered
            collection :offered_virtual_footballers,
              as: :offered_virt_footballers,
              class: ::VirtualFootballer do
              property :footballer,
                decorator: FootballerRepresenter
            end

            collection :requested_virtual_footballers,
              as: :requested_virt_footballers,
              class: ::VirtualFootballer do
              property :footballer,
                decorator: FootballerRepresenter
            end

            property :receiver_virtual_club, as: :acceptor_club do
              property :id
              property :name
              property :stadium
              property :motto
              property :color1
              property :color2
              property :color3
              property :league_id
              property :user_id
              property :crest_pattern_id
              property :crest_pattern do
                property :id
                property :svg_url
                property :crest_shape_id, exec_context: :decorator
                def crest_shape_id
                  represented.crest_shape.id
                end
              end
              property :budget
              property :user do
                property :full_name, exec_context: :decorator

                def full_name
                  represented.fname + ' ' + represented.lname
                end
              end
            end

            property :sender_virtual_club, as: :offerer_club do
              property :id
              property :name
              property :stadium
              property :motto
              property :color1
              property :color2
              property :color3
              property :league_id
              property :user_id
              property :crest_pattern_id
              property :crest_pattern do
                property :id
                property :svg_url
                property :crest_shape_id, exec_context: :decorator
                def crest_shape_id
                  represented.crest_shape.id
                end
              end
              property :budget
              property :user do
                property :full_name, exec_context: :decorator

                def full_name
                  represented.fname + ' ' + represented.lname
                end
              end
            end
          end
        end
      end
    end
  end
end
