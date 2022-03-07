# frozen_string_literal: true

class VirtualClub < ApplicationRecord
  # this operation checks if club name is unique before creating the club
  class CheckUnique < Trailblazer::Operation
    step :check_if_club_name_is_unique_for_user_this_season

    def check_if_club_name_is_unique_for_user_this_season(params:, **)
      # TODO: include user model in query to check
      # if name is unique for user this season
      virtual_club = VirtualClub.find_by_name(params[:club_name])
      virtual_club.nil?
    end
  end
end
