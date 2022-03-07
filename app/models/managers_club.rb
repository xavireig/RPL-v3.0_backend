# frozen_string_literal: true

# relation model between manager and club
class ManagersClub < ApplicationRecord
  belongs_to :club
  belongs_to :manager
end
