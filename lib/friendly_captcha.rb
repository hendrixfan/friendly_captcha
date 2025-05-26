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

  # v2 API uses API key instead of secret
  setting :api_key
  setting :site_key
  setting :verification_endpoint, default: "https://global.frcapi.com/api/v2/captcha/siteverify"
  setting :eu_endpoint, default: "https://eu.frcapi.com/api/v2/captcha/siteverify"
  setting :source, default: 'https://cdn.jsdelivr.net/npm/@friendlycaptcha/sdk@0.1.22/site.min.js'
  setting :source_compat, default: 'https://cdn.jsdelivr.net/npm/@friendlycaptcha/sdk@0.1.22/site.compat.min.js'
  setting :strict_mode, default: false
end
