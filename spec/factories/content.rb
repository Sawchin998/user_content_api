# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    title { 'Sample Title' }
    body  { 'This is a sample content body.' }
    association :user
  end
end
