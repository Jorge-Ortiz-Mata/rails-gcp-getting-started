# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    trait :with_name do
      name { 'My first post' }
    end
  end
end
