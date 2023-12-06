# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  let!(:representative) { Representative.create!(name: 'Leah Wang') }
  let!(:news_item) do
    NewsItem.create!(
      title:          'Sample News',
      description:    'Sample Description',
      link:           'http://example.com',
      issue:          'Climate Change',
      representative: representative
    )
  end
  let(:valid_attributes) do
    {
      title:             'Updated News',
      description:       'Updated Description',
      link:              'http://example.com',
      issue:             'Immigration',
      representative_id: representative.id
    }
  end
  let(:invalid_attributes) do
    { title: '', description: '', link: '', issue: '', representative_id: nil }
  end

  before do
    user = User.create!(provider: 1, uid: '123456789', email: 'test@example.com', first_name: 'Test', last_name: 'User')
    session[:current_user_id] = user.id
  end

  describe 'GET #new' do
    it 'assigns a new news_item as @news_item' do
      get :new, params: { representative_id: representative.id }
      expect(assigns(:news_item)).to be_a_new(NewsItem)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested news_item' do
        put :update, params: { id: news_item.id, news_item: valid_attributes, representative_id: representative.id }
        news_item.reload
        expect(news_item.title).to eq('Updated News')
        expect(news_item.issue).to eq('Immigration') # Test for issue update
      end

      it 'redirects to the news_item' do
        put :update, params: { id: news_item.id, news_item: valid_attributes, representative_id: representative.id }
        expect(response).to redirect_to(representative_news_item_path(representative, news_item))
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested news_item as @news_item' do
        get :edit, params: { id: news_item.id, representative_id: representative.id }
        expect(assigns(:news_item)).to eq(news_item)
      end
    end

    context 'with invalid params' do
      it 're-renders the "edit" template' do
        put :update, params: { id: news_item.id, news_item: invalid_attributes, representative_id: representative.id }
        expect(response).to render_template(:edit)
      end
    end
  end
end
