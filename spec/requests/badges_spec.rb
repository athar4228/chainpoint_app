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
end
