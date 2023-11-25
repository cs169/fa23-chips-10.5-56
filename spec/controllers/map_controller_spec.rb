# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapController, type: :controller do
  let(:state) do
    State.create!(
      name: 'Texas', symbol: 'TX', fips_code: 48, is_territory: 0,
      lat_min: 25.84, lat_max: 36.5, long_min: -106.65, long_max: -93.51
    )
  end

  let(:county) do
    County.create!(name: 'Travis', state: state, fips_code: 1, fips_class: 'H1')
  end

  describe 'GET #index' do
    it 'renders the map of the United States' do
      get :index
      expect(assigns(:states)).to eq(State.all)
      expect(assigns(:states_by_fips_code)).not_to be_nil
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #state' do
    context 'when state exists' do
      it 'renders the map of the counties of the state' do
        get :state, params: { state_symbol: state.symbol }
        expect(assigns(:state)).to eq(state)
        expect(assigns(:county_details)).not_to be_nil
        expect(response).to render_template(:state)
      end
    end

    context 'when state does not exist' do
      it 'redirects to root with an alert' do
        get :state, params: { state_symbol: 'ZZ' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/State 'ZZ' not found./)
      end
    end
  end

  describe 'GET #county' do
    context 'when state and county exist' do
      it 'redirects to search representatives path' do
        get :county, params: { state_symbol: state.symbol, std_fips_code: county.std_fips_code }
        expect(response).to redirect_to(search_representatives_path(address: county.name))
      end
    end

    context 'when state does not exist' do
      it 'redirects to root with an alert' do
        get :county, params: { state_symbol: 'ZZ', std_fips_code: '02' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/State 'ZZ' not found./)
      end
    end

    context 'when county does not exist' do
      it 'redirects to root with an alert' do
        get :county, params: { state_symbol: state.symbol, std_fips_code: '99' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/County with code '99' not found for TX/)
      end
    end
  end
end
