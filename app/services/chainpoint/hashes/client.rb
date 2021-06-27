# frozen_string_literal: true

module Chainpoint
  class Hashes::Client < Api::Base
    URL = [BASE_URL, 'hashes'].join('/')

    def submit(hash_params:)
      make_request(end_point: URL, request_type: :post, params: hash_params)
    end
  end
end
