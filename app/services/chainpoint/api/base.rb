# frozen_string_literal: true

require 'uri'
require 'net/http'

module Chainpoint
  module Api
    class Base
      class RequestFailureError < StandardError; end

      BASE_URL = Rails.application.credentials.dig(:chainport, :base_url)

      def make_request(end_point:, request_type:, params: {})
        url = URI(end_point)
        http = Net::HTTP.new(url.host, url.port)
        http.open_timeout = 5
        http.read_timeout = 10
        http.use_ssl = false
        http.verify_mode = Rails.application.credentials.dig(:chainport, :ssl_enabled)

        # TODO: Add support for all request types
        response =  case request_type
                    when :post
                      make_post_request(url, http, params)
                    end
        JSON.parse(response.read_body)
      end

      private

      def make_post_request(url, http, params = {})
        with_connection_retry do
          request = Net::HTTP::Post.new(url)
          request['Content-Type'] = 'application/json'
          request['Accept'] = 'application/json'
          request.body = params.to_json
          response = http.request(request)

          if response.code.to_i < 200 || response.code.to_i > 400
            Rails.logger.error("[Chainpoint] [POST] #{response.body.inspect}")
            raise RequestFailureError
          end

          return response
        end
      end

      # Retry mechanism
      def with_connection_retry
        retries = 0
        loop do
          yield
        rescue StandardError => e
          Rails.logger.error("[Chainpoint] Exception #{e.inspect}")
          retries += 1
          raise e if retries > 1
        end
      end
    end
  end
end
