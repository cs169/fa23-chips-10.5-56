# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItemsController, type: :controller do
  let!(:representative) { Representative.create!(name: 'John Doe') }
  let!(:news_item1) {
    NewsItem.create!(
      title: 'News 1', 
      link: 'http://news1.com/hahaha', 
      issue: 'Climate Change',
      representative: representative
    )
  }
  let!(:news_item2) {
    NewsItem.create!(
      title: 'News 2', 
      link: 'http://news2.com/hehehe', 
      issue: 'Immigration',
      representative: representative
    )
  }

  describe 'GET #index' do
    it 'assigns all news_items of a representative as @news_items' do
      get :index, params: { representative_id: representative.id }
      expect(assigns(:news_items)).to match_array([news_item1, news_item2])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested news_item as @news_item' do
      get :show, params: { id: news_item1.id, representative_id: representative.id }
      expect(assigns(:news_item)).to eq(news_item1)
    end
  end
end
