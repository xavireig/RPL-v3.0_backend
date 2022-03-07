# frozen_string_literal: true

# draft history
class DraftHistory < ApplicationRecord
  # to run background worker and update job id
  class Job < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::DraftHistory, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step :job_id_empty?
    failure :failure, fail_fast: true
    step :run_worker!
    step :update_job_id!
    step :restart_timer!

    private

    def job_id_empty?(options)
      !options['model'].job_id.present?
    end

    def failure(_options); end

    def run_worker!(options)
      options['job_id'] =
        AutoPickWorker.perform_at(
          Time.current + options['model'].virtual_club.pick_time,
          options['model'].id
        )
        Rails.logger.fatal "Creating AutoPickJob for DH: #{options['model'].id}"
    end

    def update_job_id!(options)
      options['model'].update_attribute(:job_id, options['job_id'])
    end

    def restart_timer!(options)
      ::DraftHistory::RestartTimer.call(id: options['model'].id)
    end
  end
end
