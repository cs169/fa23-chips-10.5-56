# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  describe 'GET #counties' do
    context 'when state exists' do
      let!(:state) do
        State.create!(name: 'Texas', symbol: 'TX', fips_code: 48, is_territory: 0,
                      lat_min: 25.84, lat_max: 36.5, long_min: -106.65, long_max: -93.51)
      end
      let(:counties) do
        [County.create!(name: 'Travis', state: state, fips_code: 1, fips_class: 'H1'),
         County.create!(name: 'Harris', state: state, fips_code: 2, fips_class: 'H1')]
      end

      before do
        counties
        get :counties, params: { state_symbol: 'TX' }
      end

      it 'returns the counties for the state' do
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.map { |county| county['name'] }).to match_array(%w[Travis Harris])
      end
    end
  end
end
