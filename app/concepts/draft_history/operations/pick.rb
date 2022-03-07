# frozen_string_literal: true
require 'rpl_logger'

# draft history created based on selected footballer
class DraftHistory
  # to auto pick virtual footballer
  class Pick < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :virtual_footballer_id
      validates :virtual_footballer_id, presence: true
      validates :id, presence: true
    end

    step Model(::DraftHistory, :find_by)
    step :draft_history_has_vf?
    failure :draft_history_already_taken, fail_fast: true
    step :update_draft_history!
    failure :notify_player_already_drafted, fail_fast: true
    step :assign_virtual_club!
    success :remove_current_job!
    step :broadcast_footballer_recruited
    step :increment_iteration_and_step!
    step :remove_footballer_from_all_preferred_queues!
    step :find_current_drafting_club
    failure :change_draft_status_to_processing!
    failure :persist_league!
    failure :broadcast_draft_end
    failure :create_lineups!
    failure :change_draft_status_to_completed!
    failure :persist_league!, fail_fast: true
    step :broadcast_next_auto_pick
    step :create_draft_history!
    step :start_next_turn

    private

    def draft_history_has_vf?(options)
      RplLogger.drafting_log(options['model'].league_id, "***** NEW PICK ===== ")
      RplLogger.drafting_log(options['model'].league_id, "League: #{options['model'].league_id}")
      RplLogger.drafting_log(options['model'].league_id, "DraftHistory: #{options['model'].id}")
      !options['model'].virtual_footballer.present?
    end

    def draft_history_already_taken(_options); end

    def update_draft_history!(options, params:, **)
      taken_footballers = options['model'].league.draft_histories.pluck(:virtual_footballer_id)
      RplLogger.drafting_log(options['model'].league_id, "already taken footballers #{taken_footballers}")
      RplLogger.drafting_log(options['model'].league_id, "Updating draft history with vf: #{params[:virtual_footballer_id]}")
      result = ::DraftHistory::Update.call(
        id: options['model'].id,
        virtual_footballer_id: params[:virtual_footballer_id]
      )
      if result.success?
        RplLogger.drafting_log(options['model'].league_id, "Successfully updated DH")
        options['model'] = result['model']
      else
        RplLogger.drafting_log(options['model'].league_id, "Unable to update DH: #{options['model'].id} with #{params[:virtual_footballer_id]}")
        false
      end
    end

    def notify_player_already_drafted(options)
      RplLogger.drafting_log(options['model'].league_id, "Notifying player drafted")
      user_id = options['model'].virtual_club.user.id
      ActionCable.server.broadcast "user_channel_#{user_id}",
        type: 'player_taken',
        message: 'Player already drafted!'
    end

    def assign_virtual_club!(options, params:, **)
      RplLogger.drafting_log(options['model'].league_id, "VirtualClub assigned!")

      VirtualFootballer.where(id: params[:virtual_footballer_id]).
        update(virtual_club_id: options['model'].virtual_club.id)
    end

    def remove_current_job!(options)
      RplLogger.drafting_log(options['model'].league_id, "Removing job for DH: #{options['model'].id}")

      ss = Sidekiq::ScheduledSet.new
      ss.each { |job| job.delete if job.jid.eql?(options['model'].job_id) }
      options['model'].update_attribute(:job_id, nil)
    end

    def broadcast_footballer_recruited(options, params:, **)
      RplLogger.drafting_log(options['model'].league_id, "Broadcast footballer recruted")

      options['league'] = options['model'].league
      draft_history =
        ::Api::V1::DraftHistory::Show.call['representer.render.class'].
          new(options['model'])
      ActionCable.server.broadcast(
        "draft_channel_league_#{options['league'].id}",
        type: 'footballer_recruited',
        draft_history: draft_history,
        footballer_id: params[:virtual_footballer_id]
      )
    end

    def increment_iteration_and_step!(options)
      RplLogger.drafting_log(options['model'].league_id, "Incrementing iteration and step")
      current_step = options['league'].current_step + 1
      required_teams = options['league'].required_teams
      options['league'].draft_order.update_attributes(
        current_iteration:
          options['league'].current_iteration +
              (current_step / required_teams),
        current_step: current_step % required_teams
      )
    end

    def remove_footballer_from_all_preferred_queues!(options, params:, **)
      RplLogger.drafting_log(options['model'].league_id, "removing from preffered queue")
      pfqs =
        options['league'].preferred_footballers.includes(virtual_club: [:user]).
          where(virtual_footballer_id: params[:virtual_footballer_id])
      pfqs.each do |pfq|
        pfq.destroy
        ActionCable.server.broadcast "user_channel_#{pfq.virtual_club.user.id}",
          type: 'removed_from_queue',
          message: 'Your preferred footballer has been drafted by another club',
          preferred_footballer_id: pfq.id
      end
    end

    def find_current_drafting_club(options)
      options['cdc'] = options['model'].league.current_drafting_club
      RplLogger.drafting_log(options['model'].league_id, "Next drafting club is: #{options['cdc']&.id}")
      options['cdc'].present?
    end

    def change_draft_status_to_processing!(options)
      RplLogger.drafting_log(options['model'].league_id, "========START PROCESSING DRAFT========")
      options['league'].draft_status = 'processing'
    end

    def persist_league!(options)
      RplLogger.drafting_log(options['model'].league_id, "updating league status")
      options['league'].save
    end

    def broadcast_draft_end(options)
      RplLogger.drafting_log(options['model'].league_id, "draft ended for #{options['model'].league_id}")
      league = options['league']
      ActionCable.server.broadcast "draft_channel_league_#{league.id}",
        type: 'draft_ended',
        message: 'Draft has ended. Good luck this season!',
        league: league
    end

    # TODO: move create lineup into separate worker
    def create_lineups!(options)
      RplLogger.drafting_log(options['model'].league_id, "Lineup is creating")
      League.transaction do
        ::League::Lineup.call(league_id: options['league'].id)
      end
    end

    def change_draft_status_to_completed!(options)
      RplLogger.drafting_log(options['model'].league_id, "Lineup processing completed")
      options['league'].draft_status = 'completed'
    end

    def broadcast_next_auto_pick(options)
      RplLogger.drafting_log(options['model'].league_id, "Broadcast next auto pick")
      ActionCable.server.broadcast(
        "draft_channel_league_#{options['league'].id}",
        type: 'next_auto_pick',
        current_iteration: options['league'].draft_order.current_iteration,
        current_step: options['league'].draft_order.current_step
      )
    end

    def create_draft_history!(options)
      RplLogger.drafting_log(options['model'].league_id, "creating next draft histories")
      result = ::DraftHistory::Create.call(
        iteration: options['league'].current_iteration,
        step: options['league'].current_step,
        league_id: options['league'].id,
        virtual_club_id: options['cdc'].id
      )
      options['draft_history'] = result['model']
    end

    def start_next_turn(options)
      RplLogger.drafting_log(options['model'].league_id, "next turn started dh: #{options['draft_history'].id}")
      ::DraftHistory::Job.call(id: options['draft_history'].id)
    end
  end
end
