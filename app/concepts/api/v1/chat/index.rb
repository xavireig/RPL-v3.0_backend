# frozen_string_literal: true

# Format all chats with club name
module Api
  module V1
    module Chat
      # to fetch all chat
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::Chat, decorator: ChatRepresenter
        end
      end
    end
  end
end
