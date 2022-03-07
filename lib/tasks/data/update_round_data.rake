# frozen_string_literal: true
namespace :data do
  desc 'populate next_round/previous_round relation for old data'
  task update_round: :environment do
    Season.all.each do |season|
      rounds =
        season.rounds.order(:number).to_a

      parent_round = rounds.shift

      until(rounds.size.zero?)
        child_round = rounds.shift
        child_round.update_column(:parent_id, parent_round.id)
        parent_round = child_round
      end
    end
  end

  desc 'populate next_game_week/previous_game_week relation for old data'
  task update_game_week: :environment do
    VirtualClub.all.each do |v_club|
      game_weeks =
        v_club.game_weeks.
          includes(virtual_round: :round).
          order('rounds.number').to_a

      parent_game_week = game_weeks.shift

      until(game_weeks.size.zero?)
        puts "----- pareent gw #{parent_game_week.id} p_id: #{parent_game_week.parent_id}"
        child_game_week = game_weeks.shift
        child_game_week.update_column(:parent_id, parent_game_week.id)
        parent_game_week = child_game_week
      end
    end
  end
end

