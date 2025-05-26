# frozen_string_literal: true

require_relative "lib/friendly_captcha/version"

Gem::Specification.new do |spec|
  spec.name          = "friendly_captcha"
  spec.version       = FriendlyCaptcha::VERSION
  spec.authors       = ["hendrixfan"]
  spec.email         = ["w.wohanka@gmail.com"]

  spec.summary       = "Ruby gem for Friendly Captcha v2 - Privacy-first bot protection"
  spec.description   = "A Ruby gem for integrating Friendly Captcha v2 into your applications. " \
                       "Friendly Captcha provides privacy-first, GDPR-compliant bot protection " \
                       "without tracking users or requiring them to solve puzzles."
  spec.homepage      = "https://github.com/hendrixfan/friendly_captcha"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hendrixfan/friendly_captcha"
  spec.metadata["changelog_uri"] = "https://github.com/hendrixfan/friendly_captcha/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/hendrixfan/friendly_captcha#readme"
  spec.metadata["bug_tracker_uri"] = "https://github.com/hendrixfan/friendly_captcha/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency 'dry-configurable', '~> 1.0'
  spec.add_dependency 'dry-monads', '~> 1.6'

  # Development dependencies
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rspec-rails', '~> 6.0'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rubocop', '~> 1.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end