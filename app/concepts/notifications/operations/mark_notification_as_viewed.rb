# frozen_string_literal: true

# Notification
class Notification < ApplicationRecord
  # to mark a notification as viewed (read)
  class MarkNotificationAsViewed < Trailblazer::Operation
    extend Contract::DSL

    step Model(::Notification, :find_by)
    failure :notification_not_found, fail_fast: true
    step :mark_notification_as_viewed

    private

    def notification_not_found(options)
      options['message'] = 'Notification does not exist!'
    end

    def mark_notification_as_viewed(options)
      options['model'].mark_as_viewed!
    end
  end
end
