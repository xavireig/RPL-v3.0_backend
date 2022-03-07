# frozen_string_literal: true

class User < ApplicationRecord
  # to create user
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :email
      property :password
      property :fname
      validates :email, presence: true
      validates :password, presence: true
      validates :fname, presence: true
    end

    # step :persist!
    # step :test!
    # binding.pry

    step Model(::User, :new)
    step :add_lname!
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    private

    def add_lname!(options)
      options['model'].lname = ''
    end

    def persist!(options, params:, **)
      if params[:email].blank?
        options['message'] = 'Email Address can\'t be blank'
        false
      elsif params[:password].blank?
        options['message'] = 'Password can\'t be blank'
        false
      elsif params[:fname].blank?
        options['message'] = 'Username can\'t be blank'
        false
      elsif User.find_by_email(params[:email]).blank?
        u = User.new(user_params(params))
        u.save!
        options['model'] = u
      else
        options['message'] = 'Email is already taken'
        false
      end
    end

    def user_params(params)
      params.permit(:fname, :lname, :email, :password, :club)
    end
  end
end
