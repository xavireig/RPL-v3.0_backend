# frozen_string_literal: true

# to send all waiver bids made by a virtual club
module Api
  module V1
    module Bid
      # to fetch all chat
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          collection :bids, class: ::Bid, as: :waiver_bids do
            property :id
            property :status
            property :footballer,
              exec_context: :decorator,
              decorator: FootballerRepresenter
            def footballer
              represented.auction.virtual_footballer.footballer
            end
            property :footballer_to_drop,
              exec_context: :decorator,
              decorator: FootballerRepresenter, render_nil: true
            def footballer_to_drop
              represented.dropped_virtual_footballer.footballer if
                represented.dropped_virtual_footballer
            end
            property :amount, as: :money_offered
          end
          property :waiver_auction_date, exec_context: :decorator, render_nil: true

          def waiver_auction_date
            represented.league.waiver_auction_process_date
          end
        end
      end
    end
  end
end
