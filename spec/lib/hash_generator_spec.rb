# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HashGenerator do
  describe '#call' do
    subject(:hash_code) { described_class.call(data) }

    let(:data) { nil }

    context 'when data is json' do
      let(:data) do
        {
          'first_name' => 'James',
          'last_name' => 'Fedrick'
        }
      end

      it 'returns valid hash code' do
        expect(hash_code).not_to be nil
        expect(hash_code.length).to eq(64)
      end
    end

    context 'when data is nil' do
      it 'returns valid hash code' do
        expect(hash_code).not_to be nil
        expect(hash_code.length).to eq(64)
      end
    end
  end
end
