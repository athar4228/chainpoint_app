# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonParser do
  describe '#call' do
    context 'when data is json' do
      subject(:json) { described_class.call(data.to_json) }

      let(:data) do
        {
          'first_name' => 'James',
          'last_name' => 'Fedrick'
        }
      end

      it 'returns valid hash code' do
        expect(json).not_to be nil
        expect(json).to eq(data)
      end
    end

    context 'when data is nil' do
      subject(:json) { described_class.call(data) }

      let(:data) { nil }

      it 'returns valid hash code' do
        expect(json).to eq({})
      end
    end
  end
end
