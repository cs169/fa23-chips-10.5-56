# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  let!(:representatives) do
    [
      Representative.create!(name: 'Representative 1'),
      Representative.create!(name: 'Representative 2')
    ]
  end

  describe 'GET #index' do
    it 'assigns all representatives as @representatives' do
      get :index
      expect(assigns(:representatives)).to match_array(representatives)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'with valid id' do
      it 'assigns the requested representative as @representative' do
        representative = representatives.first
        get :show, params: { id: representative.to_param }
        expect(assigns(:representative)).to eq(representative)
      end

      it 'renders the show template' do
        get :show, params: { id: representatives.first.to_param }
        expect(response).to render_template('show')
      end
    end

    context 'with invalid id' do
      it 'redirects to the representatives list' do
        get :show, params: { id: 'invalid' }
        expect(response).to redirect_to(representatives_path)
      end

      it 'sets a flash alert message' do
        get :show, params: { id: 'invalid' }
        expect(flash[:alert]).to match(/can't be found/)
      end
    end
  end
end
