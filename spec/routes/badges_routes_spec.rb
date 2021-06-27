# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Badges', type: :routing do
  it 'routes /badges/submit to the badges controller new action' do
    expect(get('/badges/submit')).to route_to('badges#new')
  end

  it 'routes / to the badges controller new action' do
    expect(get('/')).to route_to('badges#new')
  end
end
