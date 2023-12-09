# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItem, type: :model do
  let(:representative) { Representative.create!(name: 'John Doe') }

  describe 'associations' do
    it 'belongs to representative' do
      news_item = described_class.new(representative: representative)
      expect(news_item.representative).to eq(representative)
    end
  end

  describe 'validations' do
    it 'is valid with a valid issue' do
      news_item = described_class.new(issue: 'Immigration', representative: representative)
      expect(news_item).to be_valid
    end

    it 'is not valid without an issue' do
      news_item = described_class.new(representative: representative)
      expect(news_item).not_to be_valid
    end

    it 'is not valid with an issue not included in the ISSUES_LIST' do
      news_item = described_class.new(issue: 'Invalid Issue', representative: representative)
      expect(news_item).not_to be_valid
    end
  end
end
