# frozen_string_literal: true

module JsonParser
  def self.call(json)
    JSON.parse(json)
  rescue StandardError => e
    Rails.logger.error("Invalid json: #{json}, exception: #{e.inspect}")
    {}
  end
end
