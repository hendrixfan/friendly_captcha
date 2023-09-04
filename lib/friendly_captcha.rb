# frozen_string_literal: true

require_relative "friendly_captcha/version"

module FriendlyCaptcha
  extend Dry::Configurable

  setting :secret
  setting :site_key
  setting :verfication_endpoint, default: "https://friendlycaptcha.com/api/v1/siteverify"
end
