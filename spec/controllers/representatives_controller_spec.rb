# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentativesController, type: :controller do
  describe 'GET #index' do
    let!(:representatives) do
      [
        Representative.create!(name: 'Representative 1'),
        Representative.create!(name: 'Representative 2')
      ]
    end

    it 'assigns all representatives as @representatives' do
      get :index
      expect(assigns(:representatives)).to match_array(representatives)
    end
  end
end
