# frozen_string_literal: true

module Api
  module V1
    module League
      # invite users to join league
      class BasicSettings < ::League::BasicSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # league_basic_settings
      class DraftTimeSettings < ::League::DraftTimeSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # represent transfer dealine
      class TransferDeadlineSettings < ::League::TransferDeadlineSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # represent scoring type
      class ScoringTypeSettings < ::League::ScoringTypeSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # to update scoring type settings
      class ScoringCustomizeSettings < ::League::ScoringCustomizeSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # to update formation type settings
      class FormationSettings < ::League::FormationSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # to represent updated squad settings
      class SquadSettings < ::League::SquadSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # to represent scoring advanced options
      class ScoringAdvancedSettings < ::League::ScoringAdvancedSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end

      # to represent draft order
      class DraftOrderSettings < ::League::DraftOrderSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
