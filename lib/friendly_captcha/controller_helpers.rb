module FriendlyCaptcha
  module ControllerHelpers
    include Import[
      'http_call'
    ]
    def verify_friendly_captcha(options = {})
      code, _headers, body = yield http_call.(url: "#{HOST}#{path}", method: :post)
    end
  end
end
