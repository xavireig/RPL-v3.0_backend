# frozen_string_literal: true

# worker to update virtual club stats after every game week
class UpdateVirtualClubStats
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    open_rounds = Season.current_season.rounds.where(status: 'running')

    leagues = League.includes(:virtual_clubs).where(draft_status: 'completed')
    leagues.each do |l|
      open_rounds.each do |r|
        # skip calculation if all fixtures of round is not done
        next unless r.all_fixtures_done?
        # checking all clubs in a league has game weeks for this round
        array = l.virtual_clubs.map { |vc| vc.game_week_by_round(r.id).nil? }
        next if array.include? true
        l.virtual_clubs.each do |vc|
          game_week = vc.game_week_by_round(r.id)
          game_week_standing = vc.game_week_standing(game_week)
          game_week_place = vc.game_week_place(game_week)

          new_total_points = vc.total_pts + game_week_standing[:points]
          new_total_win = vc.total_win + game_week_standing[:win]
          new_total_loss = vc.total_loss + game_week_standing[:lost]
          new_total_draw = vc.total_draw + game_week_standing[:draw]
          new_total_score = vc.total_score + game_week_standing[:score]
          new_total_gd = vc.total_gd + game_week_standing[:gd]
          form = vc.form
          new_form = form.push(game_week_standing[:form][0])
          vc.update_attributes(
            total_pts: new_total_points,
            total_win: new_total_win,
            total_loss: new_total_loss,
            total_draw: new_total_draw,
            total_score: new_total_score,
            total_gd: new_total_gd,
            form: new_form,
            rank: game_week_place
          )
          end
      end
    end
  end
end
