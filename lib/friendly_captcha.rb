# frozen_string_literal: true

require_relative "friendly_captcha/version"
require_relative "friendly_captcha/view_helpers"
require_relative "friendly_captcha/controller_helpers"

if defined?(Rails)
  require 'friendly_captcha/railtie'
end

require 'dry-configurable'

module FriendlyCaptcha
  class Error < StandardError; end
  extend Dry::Configurable

  setting :secret
  setting :site_key
  setting :verification_endpoint, default: "https://api.friendlycaptcha.com/api/v1/siteverify"
  setting :source, default: 'https://cdn.jsdelivr.net/npm/friendly-challenge@0.9.14/widget.module.min.js'
end
