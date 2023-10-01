# frozen_string_literal: true

require_relative "friendly_captcha/version"
require_relative "friendly_captcha/view_helpers"
require 'dry-configurable'

module FriendlyCaptcha
  class Error < StandardError; end
  extend Dry::Configurable

  setting :secret
  setting :site_key
  setting :verfication_endpoint, default: "https://friendlycaptcha.com/api/v1/siteverify"
end
