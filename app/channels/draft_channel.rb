# frozen_string_literal: true

# draft channel
class DraftChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
    current_user.appear!
    @lock = false
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    current_user.disappear!
  end

  def start_draft(_params)
    result = ::League::StartDraft.call(id: league.id)
    if result.success?
      ActionCable.server.broadcast stream_name,
        type: 'draft_started',
        message: 'Draft Started!',
        league: result['model']
      start_auto_pick
    else
      ActionCable.server.broadcast stream_name,
        type: 'draft_started',
        message: result['message'],
        league: result['model']
    end

  end

  def draft_player(params)
    if league.reload.latest_draft_history&.virtual_club&.eql?(virtual_club) && !@lock
      @lock = true
      virtual_footballer_id =
        params.fetch('message').fetch('virtual_footballer_id')
      ::DraftHistory::Pick.call(
        id: league.reload.latest_draft_history.id,
        virtual_footballer_id: virtual_footballer_id
      )
    else
      ActionCable.server.broadcast "user_channel_#{current_user.id}",
        type: 'not_your_turn',
        message: 'Please wait for your turn!'
    end

  ensure
    @lock = false
  end

  private

  def stream_name
    "draft_channel_league_#{league.id}"
  end

  def virtual_club
    @_virtual_club ||=
      VirtualClub.find_by(league_id: league.id, user_id: current_user.id)
  end

  def league
    @_league ||= League.find(params.fetch('data').fetch('league'))
  end

  def start_auto_pick
    cdc = league.current_drafting_club
    result = ::DraftHistory::Create.call(
      iteration: league.current_iteration,
      step: league.current_step,
      league_id: league.id,
      virtual_club_id: cdc.id
    )
    ::DraftHistory::Job.call(id: result['model'].id)
  end
end
