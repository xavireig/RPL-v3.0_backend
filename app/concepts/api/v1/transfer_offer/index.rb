# frozen_string_literal: true

module Api
  module V1
    module TransferOffer
      # gets user's offered bids and requested bids
      class Index < ::TransferOffer::Index
        extend Representer::DSL

        representer :render do
          include Representable::JSON


          collection :offered_transfer_offers,
            class: ::TransferOffer,
            as: :offered_bids,
            exec_context: :decorator, render_nil: true do
            property :id
            property :status
            property :offerer, exec_context: :decorator do
              property :id
              property :fname
              property :lname
              property :full_name
              property :email
            end
            def offerer
              represented.sender_virtual_club.user
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

            property :acceptor, exec_context: :decorator do
              property :id
              property :fname
              property :lname
              property :full_name
              property :email
            end

            def acceptor
              represented.receiver_virtual_club.user
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
            property :message
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
          end

          collection :requested_transfer_offers,
            class: ::TransferOffer,
            as: :requested_bids,
            exec_context: :decorator do
            property :id
            property :status
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
            property :message
            property :amount, as: :money_offered
            property :offerer, exec_context: :decorator do
              property :id
              property :fname
              property :lname
              property :full_name
              property :email
            end
            def offerer
              represented.sender_virtual_club.user
            end

            property :acceptor, exec_context: :decorator do
              property :id
              property :fname
              property :lname
              property :full_name
              property :email
            end

            def acceptor
              represented.receiver_virtual_club.user
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
          end

          def offered_transfer_offers
            represented.offered_transfer_offers
          end

          def requested_transfer_offers
            represented.requested_transfer_offers
          end
        end
      end
    end
  end
end
