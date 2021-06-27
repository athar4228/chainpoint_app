# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chainpoint::Hashes::Client do
  describe 'URL' do
    it 'returns hashes endpoint' do
      expect(Chainpoint::Hashes::Client::URL).to eq("#{Chainpoint::Api::Base::BASE_URL}/hashes")
    end
  end

  describe '#make_request', vcr: true do
    let(:service) { described_class.new }

    describe 'when request is valid' do
      subject(:response) { service.submit(hash_params: hash_params) }

      let(:hash_params) do
        {
          hashes: ['74234e98afe7498fb5daf1f36ac2d78acc339464f950703b8c019892f982b90b']
        }
      end

      it 'returns valid response code and body' do
        expect(response['meta']).not_to be nil
        expect(response['hashes'].length).to eq 1
      end
    end

    describe 'when request is invalid' do
      subject(:response) { service.submit(hash_params: hash_params) }

      let(:hash_params) { nil }

      it 'returns valid response code and body' do
        expect { response }.to raise_error(Chainpoint::Api::Base::RequestFailureError)
      end
    end
  end
end
