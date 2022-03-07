# frozen_string_literal: true

# preferred footballer model
class PreferredFootballer < ApplicationRecord
  belongs_to :virtual_club
  belongs_to :virtual_footballer

  acts_as_list scope: :virtual_club
end
