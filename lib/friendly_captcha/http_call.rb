require 'net/http'
require 'openssl'
require 'dry/monads'
require 'dry/effects'

module FriendlyCaptcha
  class HTTPCall
    include ::Dry::Monads[:try, :result]
    include ::Dry::Effects.Timestamp
    include ::Dry::Effects.Timeout(:http)

    def call
      Try[] { perform(url, method, headers, body, **options) }
    end
  end
end
