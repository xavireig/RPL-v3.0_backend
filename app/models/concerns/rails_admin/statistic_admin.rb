# frozen_string_literal: true

module RailsAdmin
  # Rails admin config for Statistic model
  module StatisticAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        navigation_label 'Opta'
        navigation_icon 'fa fa-line-chart'
        label_plural 'Statistics'
      end
    end
  end
end
