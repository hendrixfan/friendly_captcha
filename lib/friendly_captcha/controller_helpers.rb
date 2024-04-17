# frozen_string_literal: true

require_relative "http_call"
module FriendlyCaptcha
  module ControllerHelpers
    def verify_friendly_captcha(_options = {})
      _, _headers, = FriendlyCaptcha::HttpCall.new.call(
        url: FriendlyCaptcha.config.verification_endpoint,
        body: {
          secret: FriendlyCaptcha.config.secret,
          solution: recaptcha_response_token
        }
      )
    end

    def recaptcha_response_token
      response_param = params['frc-captcha-solution']
      if response_param.is_a?(String)
        response_param
      else
        ''
      end
    end
  end
end
