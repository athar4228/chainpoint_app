# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Badges::Submit do
  describe '#initialize' do
    describe 'when badge exist' do
      subject(:submit_service) { described_class.new(badge: badge) }

      let(:badge) { build(:badge) }

      it 'set badge as attribute' do
        expect(submit_service.badge).not_to be nil
      end
    end

    describe 'when badge does not exist' do
      subject(:submit_service) { described_class.new }

      it 'throws exception' do
        expect { submit_service }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#call' do
    let(:badge) { build(:badge) }
    let(:submit_service) { described_class.new(badge: badge) }
    let(:hashes_client) { Chainpoint::Hashes::Client.new }

    before do
      allow(Chainpoint::Hashes::Client).to receive(:new).and_return(hashes_client)
    end

    describe 'when Chainpoint submit is successful' do
      let(:submit_response) do
        {
          meta: [1, 2, 3],
          hashes: [
            badge_uuid: Faker::Internet.uuid
          ]
        }
      end

      before do
        allow(hashes_client).to receive(:submit).and_return(submit_response.as_json)
        submit_service.call
      end

      it 'returns true for successful' do
        expect(submit_service.success?).to be(true)
      end

      it 'returns false for failure?' do
        expect(submit_service.failure?).to be(false)
      end

      it 'returns valid response for response_details' do
        expect(submit_service.response_details).not_to be nil
      end
    end

    describe 'when Chainpoint submit is failure' do
      subject { submit_service.call }

      let(:submit_response) do
        {
          code: 'InvalidArgument',
          message: 'invalid JSON body, missing hashes'
        }
      end

      before do
        allow(hashes_client).to receive(:submit).and_return(submit_response.as_json)
        submit_service.call
      end

      it 'returns true for successful' do
        expect(submit_service.success?).to be(false)
      end

      it 'returns false for failure?' do
        expect(submit_service.failure?).to be(true)
      end
    end

    describe 'when Chainpoint API throws error' do
      subject { submit_service.call }

      before do
        allow(hashes_client).to receive(:submit).and_raise(StandardError)
        submit_service.call
      end

      it 'returns true for successful' do
        expect(submit_service.success?).to be(false)
      end

      it 'returns false for failure?' do
        expect(submit_service.failure?).to be(true)
      end
    end
  end
end
