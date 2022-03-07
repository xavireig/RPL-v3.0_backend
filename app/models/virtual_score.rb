# frozen_string_literal: true

# virtual score model
class VirtualScore < ApplicationRecord

  #
  # associations
  #

  belongs_to :virtual_fixture
  has_one :home_virtual_club, through: :virtual_fixture
  has_one :away_virtual_club, through: :virtual_fixture
end
