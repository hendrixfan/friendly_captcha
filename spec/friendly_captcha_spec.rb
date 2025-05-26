# frozen_string_literal: true

RSpec.describe FriendlyCaptcha do
  it "has a version number" do
    expect(FriendlyCaptcha::VERSION).not_to be nil
  end

  describe "configuration" do
    before do
      # Reset configuration before each test
      FriendlyCaptcha.configure do |config|
        config.api_key = nil
        config.site_key = nil
        config.verification_endpoint = "https://global.frcapi.com/api/v2/captcha/siteverify"
        config.strict_mode = false
      end
    end

    it "can be configured with API key and site key" do
      FriendlyCaptcha.configure do |config|
        config.api_key = "test-api-key"
        config.site_key = "test-site-key"
      end

      expect(FriendlyCaptcha.config.api_key).to eq("test-api-key")
      expect(FriendlyCaptcha.config.site_key).to eq("test-site-key")
    end

    it "has default verification endpoint for v2 API" do
      expect(FriendlyCaptcha.config.verification_endpoint).to eq("https://global.frcapi.com/api/v2/captcha/siteverify")
    end

    it "has EU endpoint available" do
      expect(FriendlyCaptcha.config.eu_endpoint).to eq("https://eu.frcapi.com/api/v2/captcha/siteverify")
    end

    it "has v2 widget source URLs" do
      expect(FriendlyCaptcha.config.source).to include("@friendlycaptcha/sdk")
      expect(FriendlyCaptcha.config.source_compat).to include("@friendlycaptcha/sdk")
    end
  end

  describe FriendlyCaptcha::ViewHelpers do
    include FriendlyCaptcha::ViewHelpers

    before do
      FriendlyCaptcha.configure do |config|
        config.site_key = "test-site-key"
      end
    end

    it "generates widget HTML with site key" do
      html = friendly_captcha
      expect(html).to include('class="frc-captcha"')
      expect(html).to include('data-sitekey="test-site-key"')
      expect(html).to include('data-start="auto"')
    end

    it "accepts custom options" do
      html = friendly_captcha(start: "focus", lang: "de")
      expect(html).to include('data-start="focus"')
      expect(html).to include('lang="de"')
    end

    it "includes both modern and legacy scripts" do
      html = friendly_captcha
      expect(html).to include('type="module"')
      expect(html).to include('nomodule')
      expect(html).to include('@friendlycaptcha/sdk')
    end

    it "raises error when no site key provided" do
      FriendlyCaptcha.configure { |config| config.site_key = nil }
      expect { friendly_captcha }.to raise_error(ArgumentError, "site_key is required")
    end
  end

  describe FriendlyCaptcha::ControllerHelpers do
    include FriendlyCaptcha::ControllerHelpers

    let(:params) { { 'frc-captcha-response' => 'test-response-token' } }

    before do
      FriendlyCaptcha.configure do |config|
        config.api_key = "test-api-key"
        config.site_key = "test-site-key"
      end

      # Mock the params method
      allow(self).to receive(:params).and_return(params)
    end

    describe "#friendly_captcha_response_token" do
      it "extracts response token from params" do
        token = friendly_captcha_response_token
        expect(token).to eq("test-response-token")
      end

      it "returns empty string when no token provided" do
        allow(self).to receive(:params).and_return({})
        token = friendly_captcha_response_token
        expect(token).to eq("")
      end

      it "accepts custom field name" do
        allow(self).to receive(:params).and_return({ 'custom-field' => 'custom-token' })
        token = friendly_captcha_response_token(field_name: 'custom-field')
        expect(token).to eq("custom-token")
      end
    end

    describe "#verify_friendly_captcha" do
      it "returns error when no response token provided" do
        allow(self).to receive(:params).and_return({})
        result = verify_friendly_captcha
        expect(result[:success]).to be false
        expect(result[:error]).to include("No captcha response provided")
      end
    end
  end
end