# frozen_string_literal: true

require_relative "http_call"

module FriendlyCaptcha
  module ControllerHelpers
    def verify_friendly_captcha(options = {})
      response_token = friendly_captcha_response_token(options)
      
      return { success: false, error: "No captcha response provided" } if response_token.empty?
      
      result = FriendlyCaptcha::HttpCall.new.call(
        url: options[:endpoint] || FriendlyCaptcha.config.verification_endpoint,
        body: {
          response: response_token,
          sitekey: options[:sitekey] || FriendlyCaptcha.config.site_key
        },
        headers: {
          'X-API-Key' => options[:api_key] || FriendlyCaptcha.config.api_key,
          'Content-Type' => 'application/json'
        }
      )
      
      case result
      when FriendlyCaptcha::HttpCall::Success
        status_code, response_body = result.value!
        parse_verification_response(status_code, response_body)
      when FriendlyCaptcha::HttpCall::Failure
        handle_verification_failure(result.failure)
      end
    end

    def friendly_captcha_response_token(options = {})
      field_name = options[:field_name] || 'frc-captcha-response'
      response_param = params[field_name]
      
      if response_param.is_a?(String)
        response_param.strip
      else
        ''
      end
    end

    private

    def parse_verification_response(status_code, response_body)
      return handle_verification_failure("HTTP #{status_code}") unless status_code == 200
      
      begin
        parsed_response = JSON.parse(response_body)
        
        if parsed_response['success']
          {
            success: true,
            challenge_timestamp: parsed_response.dig('data', 'challenge', 'timestamp')
          }
        else
          error_info = parsed_response['error'] || {}
          {
            success: false,
            error: error_info['detail'] || 'Unknown verification error',
            error_code: error_info['error_code']
          }
        end
      rescue JSON::ParserError
        handle_verification_failure("Invalid JSON response")
      end
    end

    def handle_verification_failure(error)
      if FriendlyCaptcha.config.strict_mode
        {
          success: false,
          error: "Verification failed: #{error}"
        }
      else
        # In non-strict mode, assume success when verification fails
        # This prevents blocking users when the API is down
        {
          success: true,
          error: "Verification failed but allowed in non-strict mode: #{error}",
          fallback: true
        }
      end
    end
  end
end