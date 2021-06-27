# frozen_string_literal: true

module HashGenerator
  def self.call(data)
    Digest::SHA256.hexdigest(data.to_json)
  rescue StandardError => e
    Rails.logger.error("[HashGenerator] Exception Occured. data: #{data}, exception: #{e.inspect}")
    nil
  end
end
