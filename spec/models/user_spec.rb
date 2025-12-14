# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many contents' do
      assoc = described_class.reflect_on_association(:contents)
      expect(assoc.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    context 'when first_name is present' do
      it 'is valid' do
        user = build(:user, first_name: 'John')
        expect(user).to be_valid
      end
    end

    context 'when first_name is missing' do
      it 'is invalid' do
        user = build(:user, first_name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:first_name]).to include("can't be blank")
      end
    end

    context 'when last_name is present' do
      it 'is valid' do
        user = build(:user, last_name: 'Doe')
        expect(user).to be_valid
      end
    end

    context 'when last_name is missing' do
      it 'is invalid' do
        user = build(:user, last_name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:last_name]).to include("can't be blank")
      end
    end
  end

  describe '#confirmed?' do
    it 'always returns true' do
      user = build(:user)
      expect(user.confirmed?).to eq(true)
    end
  end
end
