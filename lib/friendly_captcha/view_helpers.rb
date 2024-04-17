# frozen_string_literal: true

module FriendlyCaptcha
  module ViewHelpers
    def friendly_captcha(opts = {})
      site_key ||= FriendlyCaptcha.config.site_key
      html = <<-HTML
        <div class="frc-captcha"  data-sitekey="#{site_key}" data-start="auto"></div>
      HTML
      html << %(<script type="module" src="https://cdn.jsdelivr.net/npm/friendly-challenge@0.9.14/widget.module.min.js" async defer></script>\n)
      html.respond_to?(:html_safe) ? html.html_safe : html
    end
  end
end
