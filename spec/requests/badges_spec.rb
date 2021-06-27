# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Badges', type: :request do
  describe 'GET submit' do
    it 'is successful and render new template' do
      get '/badges/submit'

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    describe 'when params are valid' do
      let(:badge) { build(:badge) }
      let(:badge_params) do
        {
          badge: {
            name: badge.name,
            uuid: badge.uuid,
            issue_date: badge.issue_date
          }
        }
      end
      let(:hashes_client) { Chainpoint::Hashes::Client.new }

      let(:submit_response) do
        {
          meta: [1, 2, 3],
          hashes: [
            {
              proof_id: '7704cc80-d754-11eb-9d42-018f57ba3ad3',
              hash: '74234e98afe7498fb5daf1f36ac2d78acc339464f950703b8c019892f982b90b'
            }
          ]
        }
      end

      before do
        allow(Chainpoint::Hashes::Client).to receive(:new).and_return(hashes_client)
        allow(hashes_client).to receive(:submit).and_return(submit_response.as_json)
      end

      it 'redirects to the success page' do
        post '/badges', params: badge_params

        follow_redirect!

        expect(response).to render_template(:success)
      end
    end

    describe 'when params are invalid' do
      let(:badge_params) do
        {
          badge: {
            name: Faker::Name.name
          }
        }
      end

      it 'fails on validation and render new' do
        post '/badges', params: badge_params

        expect(response).to render_template(:new)
      end
    end

    describe 'when params are valid but Chainpoint API fails' do
      let(:badge) { build(:badge) }
      let(:badge_params) do
        {
          badge: {
            name: badge.name,
            uuid: badge.uuid,
            issue_date: badge.issue_date
          }
        }
      end
      let(:hashes_client) { Chainpoint::Hashes::Client.new }

      let(:submit_response) do
        {
          code: 'InvalidArgument',
          message: 'invalid JSON body, missing hashes'
        }
      end

      before do
        allow(Chainpoint::Hashes::Client).to receive(:new).and_return(hashes_client)
        allow(hashes_client).to receive(:submit).and_return(submit_response.as_json)
      end

      it 'redirects to the new page with alert' do
        post '/badges', params: badge_params

        follow_redirect!

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq(
          'Something went wrong while making request to Chainpoint. Please contact administrator'
        )
      end
    end
  end

  describe 'GET success' do
    describe 'when param h is present' do
      let(:chainpoint_response) do
        {
          proof_id: '7704cc80-d754-11eb-9d42-018f57ba3ad3',
          hash: '74234e98afe7498fb5daf1f36ac2d78acc339464f950703b8c019892f982b90b',
          badge_uuid: Faker::Internet.uuid
        }.as_json
      end

      let(:h) { Base64.encode64(chainpoint_response.to_json) }

      it 'renders success template' do
        get "/badges/success?h=#{h}"

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:success)
      end
    end

    describe 'when param h is blank' do
      it 'redirects to submit page' do
        get '/badges/success?h='

        follow_redirect!

        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Please enter Badge details first')
      end
    end
  end
end
