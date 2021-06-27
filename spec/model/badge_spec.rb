# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to allow_value('763d26ad-7bb5-431f-a050-d67b9c220d63').for(:uuid) }
    it { is_expected.not_to allow_value('test').for(:uuid) }
    it { is_expected.to validate_presence_of(:issue_date) }
  end
end
