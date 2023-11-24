# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET search' do
    let(:address) { '123 Main St' }
    let(:fake_civic_info_service) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }
    let(:fake_results) { [instance_double(Representative), instance_double(Representative)] }

    before do
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(fake_civic_info_service)
      allow(fake_civic_info_service).to receive(:key=)
      allow(fake_civic_info_service).to receive(:representative_info_by_address).and_return(fake_results)
      allow(Representative).to receive(:civic_api_to_representative_params).and_return(fake_results)
    end

    it 'calls the Google CivicInfo API with the provided address' do
      get :search, params: { address: address }
      expect(fake_civic_info_service).to have_received(:representative_info_by_address).with(address: address)
    end

    it 'converts the API results into representative parameters' do
      get :search, params: { address: address }
      expect(Representative).to have_received(:civic_api_to_representative_params).with(fake_results)
    end

    it 'assigns the representatives for the view' do
      get :search, params: { address: address }
      expect(assigns(:representatives)).to eq(fake_results)
    end

    it 'renders the search template' do
      get :search, params: { address: address }
      expect(response).to render_template('representatives/search')
    end
  end
end
