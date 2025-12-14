# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name) { |n| "Firstname#{n}" }
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password { 'password123' }
  end
end
