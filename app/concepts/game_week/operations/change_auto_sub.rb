# frozen_string_literal: true

class GameWeek < ApplicationRecord
  # turn auto sub off or on
  class ChangeAutoSub < Trailblazer::Operation
    extend Contract::DSL

    step Model(::GameWeek, :find_by)
    failure :game_week_not_found, fail_fast: true
    step :check_if_current_gw
    failure :not_current_gw, fail_fast: true
    step :change_auto_sub!
    step :success_message

    private

    def game_week_not_found(options)
      options['message'] = 'Game Week not found!'
    end

    def check_if_current_gw(options)
      if options['model'].virtual_club.current_game_week.id == options['model'].id
        true
      else
        false
      end
    end

    def not_current_gw(options)
      options['message'] =
        'Whoops! You cannot activate/disable auto sub from previous/future rounds!'
    end

    def change_auto_sub!(options, params:, **)
      options['model'].auto_sub_on = params[:auto_sub]
      options['model'].save
    end

    def success_message(options)
      if options['model'].auto_sub_on
        options['message'] = 'Auto sub has been turned on!'
      else
        options['message'] = 'Auto sub has been turned off!'
      end
    end
  end
end
