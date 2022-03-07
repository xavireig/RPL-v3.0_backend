# frozen_string_literal: true

class Invitation < ApplicationRecord
  # invite member to join league
  class Invite < Trailblazer::Operation
    extend Contract::DSL

    step :find_league
    step :check_if_user_is_league_chairman
    step :validate_emails
    step :save_invites!
    step :invitations

    private

    def find_league(options, params:, **)
      league = League.find(params[:league_id])
      if league.blank?
        options['message'] = 'League not found!'
        false
      else
        options['model'] = league
      end
    end

    def check_if_user_is_league_chairman(options, params:, **)
      if options['model'].user_id != params[:current_user].id
        options['message'] = 'Only league chairman can send invites.'
        false
      else
        options['model']
      end
    end

    def validate_emails(options, params:, **)
      if params[:email_arr].blank?
        options['message'] = 'No email addresses found to send invite'
        false
      elsif params[:email_arr].size > 12
        options['message'] = 'Sorry! Too many email addresses.'
        false
      else
        true
      end
    end

    def save_invites!(options, params:, **)
      params[:email_arr].each do |email|
        next if email == params[:current_user].email
        league_invite =
          Invitation.
            where(
              league_id: params[:league_id],
              email: email, status: 'waiting'
            ).first

        next if league_invite.present?
        invitation = ::Invitation.create(
          league_id: params[:league_id],
          email: email
        )
        if invitation.save!
          send_invitation_mail(email, options, params)
        end
      end
    end

    def invitations(options, params:, **)
      options['model'] =
        Invitation.where(
          league_id: params[:league_id], email: params[:email_arr]
        )
    end

    def send_invitation_mail(email, options, params)
      @chairman = params[:current_user]
      @recipient = email
      @league = options['model']
      ::UserMailer.invite(@chairman, @recipient, @league).deliver_now
    end
  end
end
