# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:user) do
        User.create!(provider: 1, uid: '123456', email: 'leahwang61@berkeley.edu', first_name: 'Leah',
                     last_name: 'Wang')
      end
  let!(:news_item) do
    NewsItem.create!(
      title:          'Sample News',
      description:    'Sample Description',
      link:           'http://example.com',
      issue:          'Climate Change',
      representative: representative
    )
  end
  
  describe 'associations' do
    it 'belongs to a user' do
      rating = Rating.new(user: user)
      expect(rating.user).to eq(user)
    end

    it 'belongs to a news item' do
      rating = Rating.new(news_item: news_item)
      expect(rating.news_item).to eq(news_item)
    end
  end

  describe 'validations' do
    it 'is invalid if the score changes after creation' do
      rating = Rating.create!(user: user, news_item: news_item, score: 5)
      rating.score = 4
      expect { rating.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'callbacks' do
    it 'updates the news_item rating_sum after create' do
      rating_sum_before = news_item.rating_sum.to_i
      Rating.create!(user: user, news_item: news_item, score: 5)
      news_item.reload # reload the news_item to get the updated value from the database
      expect(news_item.rating_sum).to eq(rating_sum_before + 5)
    end
  end
end
