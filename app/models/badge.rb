# frozen_string_literal: true

class Badge
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :issue_date, :name, :uuid

  validates :name, presence: true
  validates :uuid, presence: true, format: { with: /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/ }
  validates :issue_date, presence: true
end
