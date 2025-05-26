# frozen_string_literal: true

module FriendlyCaptcha
  module ViewHelpers
    def friendly_captcha(opts = {})
      site_key = opts[:sitekey] || opts[:site_key] || FriendlyCaptcha.config.site_key
      start_mode = opts[:start] || "auto"
      form_field_name = opts[:form_field_name] || "frc-captcha-response"
      language = opts[:lang] || opts[:language]
      
      raise ArgumentError, "site_key is required" unless site_key

      # Build widget HTML attributes
      widget_attrs = {
        "class" => "frc-captcha",
        "data-sitekey" => site_key,
        "data-start" => start_mode
      }
      
      widget_attrs["data-form-field-name"] = form_field_name unless form_field_name == "frc-captcha-response"
      widget_attrs["lang"] = language if language
      
      # Convert attributes to HTML string
      attr_string = widget_attrs.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
      
      html = <<-HTML
        <div #{attr_string}></div>
      HTML

      # Add scripts - both modern and legacy support
      html << %(<script type="module" src="#{FriendlyCaptcha.config.source}" async defer></script>\n)
      html << %(<script nomodule src="#{FriendlyCaptcha.config.source_compat}" async defer></script>\n)
      
      html.respond_to?(:html_safe) ? html.html_safe : html
    end
  end
end
