# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  before do
    State.create!(name: 'California', symbol: 'CA', fips_code: '06', is_territory: false, lat_min: -124.409591,
                  lat_max: -114.131211, long_min: 32.534156, long_max: 42.009518)
    State.create!(name: 'Texas', symbol: 'TX', fips_code: '48', is_territory: false, lat_min: 25.837377,
                  lat_max: 36.500704, long_min: -106.645646, long_max: -93.508292)
  end

  describe '.state_ids_by_name' do
    it 'returns a hash of state names and their IDs' do
      expected_result = {
        'California' => State.find_by(name: 'California').id,
        'Texas'      => State.find_by(name: 'Texas').id
      }
      expect(described_class.state_ids_by_name).to eq(expected_result)
    end
  end

  describe '.state_symbols_by_name' do
    it 'returns a hash of state names and their symbols' do
      expected_result = {
        'California' => 'CA',
        'Texas'      => 'TX'
      }
      expect(described_class.state_symbols_by_name).to eq(expected_result)
    end
  end

  describe '.nav_items' do
    it 'returns navigation items' do
      expected_nav_items = [
        {
          title: 'Home',
          link:  Rails.application.routes.url_helpers.root_path
        },
        {
          title: 'Events',
          link:  Rails.application.routes.url_helpers.events_path
        },
        {
          title: 'Representatives',
          link:  Rails.application.routes.url_helpers.representatives_path
        }
      ]

      expect(described_class.nav_items).to eq(expected_nav_items)
    end
  end

  describe '.active' do
    it 'current controller matches nav link' do
      allow(Rails.application.routes).to receive(:recognize_path).and_return(controller: 'home')
      expect(described_class.active('home', '/')).to eq('bg-primary-active')
    end

    it 'current controller does not match nav link' do
      allow(Rails.application.routes).to receive(:recognize_path).and_return(controller: 'events')
      expect(described_class.active('home', '/')).to eq('')
    end
  end
end
