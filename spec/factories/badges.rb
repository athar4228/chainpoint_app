# frozen_string_literal: true

FactoryBot.define do
  factory :badge do
    name { Faker::Name.name }
    uuid { Faker::Internet.uuid }
    issue_date { Faker::Date.between(2.months.ago, Time.zone.today) }
  end
end
