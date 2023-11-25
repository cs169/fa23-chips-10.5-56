# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:state) do
    State.create!(
      name: 'Texas', symbol: 'TX', fips_code: 48, is_territory: 0,
      lat_min: 25.84, lat_max: 36.5, long_min: -106.65, long_max: -93.51
    )
  end

  let(:county) do
    County.create!(name: 'Travis', state: state, fips_code: 1, fips_class: 'H1')
  end

  let!(:event_in_travis) do
    Event.create!(
      name: 'Event in Travis', county: county,
      start_time: Time.zone.now + 1.day, end_time: Time.zone.now + 2.days
    )
  end

  let!(:event_in_other_county) do
    Event.create!(
      name: 'Event in Other County',
      county: County.create!(name: 'Other', state: state, fips_code: 2, fips_class: 'H2'),
      start_time: Time.zone.now + 1.day, end_time: Time.zone.now + 2.days
    )
  end

  describe 'GET #index' do
    context 'without filter' do
      it 'returns all events' do
        get :index
        expect(assigns(:events)).to match_array([event_in_travis, event_in_other_county])
      end
    end

    context 'with state-only filter' do
      it 'returns events filtered by state' do
        get :index, params: { 'filter-by' => 'state-only', 'state' => 'TX' }
        expect(assigns(:events)).to match_array([event_in_travis, event_in_other_county])
      end
    end

    context 'with county filter' do
      it 'returns events filtered by county' do
        get :index, params: { 'filter-by' => 'county', 'state' => 'TX', 'county' => county.fips_code }
        expect(assigns(:events)).to match_array([event_in_travis])
      end
    end
  end

  describe 'GET #show' do
    it 'returns the event' do
      get :show, params: { id: event_in_travis.id }
      expect(assigns(:event)).to eq(event_in_travis)
    end
  end
end
