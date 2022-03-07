# frozen_string_literal: true

# user channel
class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def add_to_queue(params)
    result = ::PreferredFootballer::Create.call(params.fetch('message'))
    if result.success?
      preferred_footballer =
        ::Api::V1::PreferredFootballer::Show.call['representer.render.class'].
          new(result['model'])
      ActionCable.server.broadcast stream_name,
        type: 'added_to_queue',
        message: 'Player added to your queue!',
        preferred_footballer: preferred_footballer
    else
      ActionCable.server.broadcast stream_name,
        type: 'added_to_queue',
        message: 'Player already taken!',
        preferred_footballer: nil
    end

  end

  def rearrange_queue(params)
    preferred_footballer_id =
      params.fetch('message').fetch('preferred_footballer_id')
    pf = PreferredFootballer.find(preferred_footballer_id)
    # in frontend index is at 0 but in backend index starts from 1
    if pf.insert_at(params.fetch('message').fetch('new_position') + 1)
      ActionCable.server.broadcast stream_name,
        type: 'rearranged_queue',
        message: 'Player moved to new position in queue!'
    end
  end

  def remove_from_queue(params)
    preferred_footballer_id =
      params.fetch('message').fetch('preferred_footballer_id')
    preferred_footballer =
      PreferredFootballer.find(preferred_footballer_id)
    if preferred_footballer.destroy
      ActionCable.server.broadcast stream_name,
        type: 'removed_from_queue',
        message: 'Player removed from queue!',
        preferred_footballer_id: preferred_footballer_id
    end
  end

  private

  def stream_name
    "user_channel_#{current_user.id}"
  end
end
