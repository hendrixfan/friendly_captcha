# FriendlyCaptcha Ruby Gem

A Ruby gem for integrating [Friendly Captcha v2](https://friendlycaptcha.com/) into your Ruby and Rails applications. Friendly Captcha is a privacy-first, GDPR-compliant captcha service that protects your websites from spam and abuse without tracking users or requiring them to solve puzzles.

## Features

- **Privacy-First**: No user tracking or data collection
- **Accessibility**: Works seamlessly for all users
- **Easy Integration**: Drop-in replacement for other captcha services
- **Rails Support**: Built-in helpers for Rails applications
- **v2 API**: Uses the latest Friendly Captcha v2 API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'friendly_captcha'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install friendly_captcha
```

## Setup

### 1. Get Your Keys

1. Sign up for a [Friendly Captcha account](https://app.friendlycaptcha.eu/)
2. Create a new application to get your:
   - **Site Key** (for frontend widget)
   - **API Key** (for backend verification)

### 2. Configure the Gem

Create an initializer file `config/initializers/friendly_captcha.rb`:

```ruby
FriendlyCaptcha.configure do |config|
  config.api_key = ENV['FRIENDLY_CAPTCHA_API_KEY']    # Your API key
  config.site_key = ENV['FRIENDLY_CAPTCHA_SITE_KEY']  # Your site key
  
  # Optional: Use EU endpoint for GDPR compliance
  # config.verification_endpoint = FriendlyCaptcha.config.eu_endpoint
  
  # Optional: Enable strict mode (reject when verification fails)
  # config.strict_mode = true
end
```

## Usage

### In Views (Rails)

Add the captcha widget to your forms:

```erb
<%= form_with url: "/submit" do |form| %>
  <%= form.text_field :email, placeholder: "Email" %>
  
  <!-- Add the Friendly Captcha widget -->
  <%= friendly_captcha %>
  
  <%= form.submit "Submit" %>
<% end %>
```

#### Customization Options

```erb
<!-- Basic usage -->
<%= friendly_captcha %>

<!-- With custom options -->
<%= friendly_captcha(
  sitekey: "your-custom-site-key",  # Override default site key
  start: "focus",                   # auto, focus, or none
  lang: "de",                       # Language code
  form_field_name: "custom-field"   # Custom form field name
) %>
```

### In Controllers (Rails)

Verify the captcha response in your controller:

```ruby
class ContactController < ApplicationController
  def create
    result = verify_friendly_captcha
    
    if result[:success]
      # Captcha verification successful
      # Process the form...
      redirect_to success_path, notice: "Thank you for your submission!"
    else
      # Captcha verification failed
      flash.now[:error] = "Please complete the captcha verification."
      render :new
    end
  end
end
```

#### Advanced Verification

```ruby
# With custom options
result = verify_friendly_captcha(
  api_key: "custom-api-key",
  sitekey: "custom-site-key",
  field_name: "custom-field-name",
  endpoint: FriendlyCaptcha.config.eu_endpoint
)

# Check the result
if result[:success]
  puts "Verification successful!"
  puts "Challenge timestamp: #{result[:challenge_timestamp]}" if result[:challenge_timestamp]
else
  puts "Verification failed: #{result[:error]}"
  puts "Error code: #{result[:error_code]}" if result[:error_code]
  puts "Fallback mode: #{result[:fallback]}" if result[:fallback]
end
```

### Non-Rails Usage

For non-Rails Ruby applications:

```ruby
require 'friendly_captcha'

# Configure
FriendlyCaptcha.configure do |config|
  config.api_key = "your-api-key"
  config.site_key = "your-site-key"
end

# Generate widget HTML
include FriendlyCaptcha::ViewHelpers
widget_html = friendly_captcha

# Verify response (in your request handler)
include FriendlyCaptcha::ControllerHelpers

# Mock params for non-Rails usage
def params
  { 'frc-captcha-response' => 'user-response-token' }
end

result = verify_friendly_captcha
```

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `api_key` | Your Friendly Captcha API key | `nil` |
| `site_key` | Your Friendly Captcha site key | `nil` |
| `verification_endpoint` | API endpoint for verification | `https://global.frcapi.com/api/v2/captcha/siteverify` |
| `eu_endpoint` | EU-only API endpoint | `https://eu.frcapi.com/api/v2/captcha/siteverify` |
| `strict_mode` | Reject when verification fails | `false` |
| `source` | Modern widget script URL | Latest v2 SDK |
| `source_compat` | Legacy browser script URL | Latest v2 SDK |

## Widget Options

| Attribute | Description | Default |
|-----------|-------------|---------|
| `sitekey` | Your site key | From config |
| `start` | When to start solving (`auto`, `focus`, `none`) | `auto` |
| `lang` | Language code (e.g., `en`, `de`, `fr`) | Auto-detected |
| `form_field_name` | Name of the hidden form field | `frc-captcha-response` |

## Error Handling

The gem includes intelligent error handling:

- **Non-strict mode** (default): If verification fails due to network issues or API problems, the captcha is accepted to avoid blocking legitimate users
- **Strict mode**: All captcha responses must be successfully verified

```ruby
# Enable strict mode
FriendlyCaptcha.configure do |config|
  config.strict_mode = true
end
```

## Testing

In your test environment, you might want to bypass captcha verification:

```ruby
# In test environment
if Rails.env.test?
  # Mock successful verification
  allow_any_instance_of(FriendlyCaptcha::ControllerHelpers)
    .to receive(:verify_friendly_captcha)
    .and_return({ success: true })
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`.

## Migration from v1

If you're upgrading from Friendly Captcha v1:

1. Update your API keys in the dashboard
2. Change form field name from `frc-captcha-solution` to `frc-captcha-response`
3. Update your configuration to use `api_key` instead of `secret`
4. The widget will automatically use the new v2 scripts

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hendrixfan/friendly_captcha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hendrixfan/friendly_captcha/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FriendlyCaptcha project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hendrixfan/friendly_captcha/blob/main/CODE_OF_CONDUCT.md).