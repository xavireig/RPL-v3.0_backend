# frozen_string_literal: true

# virtual round representer
class VirtualRoundRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :league_id
  property :round do
    property :id
    property :season_id
    property :number
    property :open?, exec_context: :decorator
    def open?
      true
    end
    property :done?, exec_context: :decorator
    def done?
      false
    end
    property :full_status, exec_context: :decorator
    def full_status
      'pending'
    end
  end
end