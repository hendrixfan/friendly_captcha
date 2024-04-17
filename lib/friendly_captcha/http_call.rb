require 'net/http'
require 'openssl'
require 'dry/monads'

module FriendlyCaptcha
  class HttpCall
    include ::Dry::Monads[:try, :result]

    Errors = [
      ::SocketError,
      ::SystemCallError,
      ::Timeout::Error,
      ::EOFError,
      ::IOError,
      ::Net::OpenTimeout,
      ::Net::HTTPBadResponse,
      ::Net::HTTPHeaderSyntaxError,
      ::Net::ProtocolError,
      ::Net::ReadTimeout,
      ::Net::WriteTimeout,
      ::OpenSSL::SSL::SSLError,
      ::URI::InvalidURIError
    ]

    def call(url:, body:, **options)
      Try[*Errors] { perform(url, body, **options) }.to_result.bind do |response|
        Success(response)
      end
    end

    def perform(url, body)
      uri = URI(url)

      options = {
        use_ssl: uri.scheme.eql?('https'),
        open_timeout: 500,
        read_timeout: 500
      }

      ::Net::HTTP.start(uri.host, uri.port, options) do |http|
        request = ::Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
        request.body = body.to_json
        response = http.request(request)

        [Integer(response.code, 10), response.body]
      end
    end
  end
end
