# frozen_string_literal: true

module Api
  module V1
    module VirtualRound
      # gets user's invites
      class Show < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          collection :virtual_fixtures,
            as: :vfs,
            decorator: Api::V1::VirtualFixture::Show.call['representer.render.class'],
            class: ::VirtualFixture
        end
      end
    end
  end
end
