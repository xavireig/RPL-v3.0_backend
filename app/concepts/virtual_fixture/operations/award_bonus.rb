# frozen_string_literal: true

class VirtualFixture < ApplicationRecord
  # this operation adds transfer bonus to the virtual clubs for virtual fixtures
  class AwardBonus < Trailblazer::Operation

    step :fetch_vr
    step :fetch_vfs
    step :award_bonus!

    private

    def fetch_vr(options, params:, **)
      options['vr'] = params[:vr]
    end

    def fetch_vfs(options)
      options['vfs'] = options['vr'].virtual_fixtures
    end

    def award_bonus!(options)
      options['vfs'].each do |vf|
        if vf.win?(vf.home_virtual_club_id)
          vf.home_virtual_club.budget += 3
          vf.home_virtual_club.save
        elsif vf.win?(vf.away_virtual_club_id)
          vf.away_virtual_club.budget += 3
          vf.away_virtual_club.save
        elsif vf.draw?
          vf.home_virtual_club.budget += 1
          vf.away_virtual_club.budget += 1
          vf.home_virtual_club.save
          vf.away_virtual_club.save
        end
      end
    end
  end
end
