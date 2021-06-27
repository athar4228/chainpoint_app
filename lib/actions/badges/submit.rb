# frozen_string_literal: true

module Actions
  module Badges
    class Submit
      attr_reader :badge, :response

      def initialize(badge:)
        @badge = badge
      end

      def call
        begin
          client = ::Chainpoint::Hashes::Client.new
          @response = client.submit(hash_params: hash_params)
        rescue StandardError => e
          Rails.logger.error("[Badges::Submit] Failed, Exception Occured: #{e.inspect}")
          @response = nil
        end

        self
      end

      def failure?
        response.nil? || response['meta'].blank? || response['hashes'].blank?
      end

      def success?
        !failure? && response['meta'].present? && response['hashes'].length.positive?
      end

      def response_details
        hash_data = response.fetch('hashes', []).first
        return if hash_data.blank?

        hash_data.merge!('badge_uuid' => @badge.uuid)
      end

      private

      def hash_params
        hash_code = HashGenerator.call(badge.chainpoint_hash_data)

        {
          hashes: [hash_code]
        }
      end
    end
  end
end
