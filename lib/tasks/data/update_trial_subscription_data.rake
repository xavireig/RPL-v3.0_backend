# frozen_string_literal: true
namespace :data do
  desc 'set trail user end_date to 25-08-2017'
  task update_trial_end_date: :environment do
    User.all.each do |user|
      next if user.subscription.blank? || !user.subscription.trial?

      user.subscription.update_column(:end_date, Time.parse('25-08-2017'))
    end
  end
end

