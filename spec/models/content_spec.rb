# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    context 'when title and body are valid' do
      it 'is valid' do
        content = build(:content, user: user)
        expect(content).to be_valid
      end
    end

    context 'when title is missing' do
      it 'is invalid' do
        content = build(:content, title: nil, user: user)
        expect(content).not_to be_valid
        expect(content.errors[:title]).to include("can't be blank")
      end
    end

    context 'when title is too long' do
      it 'is invalid' do
        content = build(:content, title: 'a' * 51, user: user)
        expect(content).not_to be_valid
        expect(content.errors[:title]).to include("is too long (maximum is 50 characters)")
      end
    end

    context 'when body is missing' do
      it 'is invalid' do
        content = build(:content, body: nil, user: user)
        expect(content).not_to be_valid
        expect(content.errors[:body]).to include("can't be blank")
      end
    end
  end
end
