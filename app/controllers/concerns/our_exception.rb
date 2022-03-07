# frozen_string_literal: true

# custom exception
class OurException < StandardError
  attr_reader :ext_code, :ext_message, :message

  def initialize(in_ext_code, in_ext_message)
    @ext_code = in_ext_code

    @ext_message = in_ext_message
    @message = in_ext_message
  end
end
