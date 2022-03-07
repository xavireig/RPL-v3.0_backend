# frozen_string_literal: true

# mapper helper container module
module MapperHelper
  private

  # print error message
  # pass error object and AR obj
  def print_err_msg(error = nil, ar_obj = nil)
    return if error.nil? && ar_obj.nil?

    # check ar_obj is ApplicationRecord obj or not
    is_ar_obj = ar_obj.present? && ar_obj.is_a?(ApplicationRecord)
    if is_ar_obj
      name = ar_obj.class.name
      msg =
        ">>> #{name} save fail because of #{ar_obj.errors.full_messages}"
      Rails.logger.info msg
    end

    print_exception(error)
  end

  def print_error(e)
    Rails.logger.error "Error during processing: #{$ERROR_INFO}"
    Rails.logger.error "Backtrace: #{e.backtrace.join('\n')}"
  end

  def print_exception(e)
    return unless e

    msg =
      ">>>> exception is #{e} and trace is #{e.backtrace.join('\n')}"
    Rails.logger.info msg
  end

  # create original_u_id attr from uid
  def original_uid(uid)
    { original_u_id: uid }
  end

  # remove prefix from uid and return int value
  def parse_uid(original_uid)
    return if original_uid.nil?

    original_uid[1..-1].to_i
  end

  # return season_id
  def season_id
    @_season_id ||=
      @_root.soccer_document[:season_id]
  end

  # return season, existing one or create
  def season
    @_season ||=
      Season.find_or_create_by(u_id: season_id) do |s|
        s.name = season_name
      end
  end

  def season_name
    @_season_name =
      @_root.soccer_document[:season_name]
  end
end
