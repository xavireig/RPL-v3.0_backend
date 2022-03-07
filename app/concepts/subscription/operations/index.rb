# frozen_string_literal: true

class Subscription < ApplicationRecord
  # get user's all league invites
  class Index < Trailblazer::Operation
    extend Contract::DSL

    step :get_brantree_plans

    private

    def get_brantree_plans(options)
      options['model'] = Braintree::Plan.all.select{|p| p.id != 'bgmw'}
    end
  end
end
