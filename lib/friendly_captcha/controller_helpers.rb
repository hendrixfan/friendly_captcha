# frozen_string_literal: true

module FriendlyCaptcha
  module ControllerHelpers
    include Import[
      "http_call"
    ]
    def verify_friendly_captcha(_options = {})
      _, _headers, = yield http_call.call(
        url: FriendlyCaptcha.verfication_endpoint,
        body: {
          secret: FriendlyCaptcha.secret,
          solution: solution
        }, method: :post
      )
    end
  end
end
