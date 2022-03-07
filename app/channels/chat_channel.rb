# frozen_string_literal: true

# chat channel
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create(params)
    chat = build_chat(params.fetch('message'))
    if chat.save
      ActionCable.server.broadcast stream_name,
        ChatRepresenter.new(chat)
    end
  end

  private

  def stream_name
    "chat_channel_league_#{league_id}"
  end

  def league_id
    params.fetch('data').fetch('league')
  end

  # current club for this league
  def club
    @_club ||=
      VirtualClub.find_by(league_id: league_id, user_id: current_user.id)
  end

  def build_chat(content)
    Chat.new(league_id: league_id, content: content, virtual_club_id: club.id)
  end
end
