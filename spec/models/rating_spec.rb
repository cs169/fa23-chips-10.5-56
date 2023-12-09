# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) { User.create!(/* appropriate user attributes */) }
  let(:news_item) { NewsItem.create!(/* appropriate news item attributes */) }

  describe 'associations' do
    it 'belongs to a user' do
      rating = described_class.new(user: user, news_item: news_item, score: 5)
      expect(rating.user).to eq(user)
    end

    it 'belongs to a news item' do
      rating = described_class.new(user: user, news_item: news_item, score: 5)
      expect(rating.news_item).to eq(news_item)
    end
  end

  describe 'validations' do
    context 'when the rating is persisted' do
      it 'is invalid if the score changes' do
        rating = described_class.create!(user: user, news_item: news_item, score: 5)
        rating.score = 4
        expect { rating.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'callbacks' do
    it 'updates the news_item rating_sum after create' do
      rating_sum_before = news_item.rating_sum.to_i
      described_class.create!(user: user, news_item: news_item, score: 5)
      expect(news_item.reload.rating_sum).to eq(rating_sum_before + 5)
    end
  end
end

