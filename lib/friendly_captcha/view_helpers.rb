# frozen_string_literal: true

module FriendlyCaptcha
  module ViewHelpers
    def friendly_captcha(opts = {})
      site_key ||= FriendlyCaptcha.config.site_key
      html = <<-HTML
        div class="frc-captcha"  data-sitekey="#{site_key}" data-start="auto"></div>
      HTML

      html
    end
  end
end
