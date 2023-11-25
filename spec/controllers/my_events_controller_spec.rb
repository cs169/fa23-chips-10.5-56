# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  let(:valid_attributes) do
    {
      name:        'Community Art Festival',
      description: 'Art and Culture',
      start_time:  '2120-05-15',
      end_time:    '2120-05-16'
    }
  end
  let(:invalid_attributes) { { name: '', county_id: nil } }

  before do
    state = State.create!(name: 'Texas', symbol: 'TX', fips_code: 48, is_territory: 0, lat_min: 25.84, lat_max: 36.5,
                          long_min: -106.65, long_max: -93.51)
    county = County.create!(name: 'Travis', state: state, fips_code: 1, fips_class: 'H1')
    user = User.create!(provider: 1, uid: '123456789', email: 'leahwang61@berkeley.edu', first_name: 'Leah',
                        last_name: 'Wang')
    valid_attributes.merge!(county_id: county.id)
    session[:current_user_id] = user.id
  end

  describe 'GET #new' do
    it 'assigns a new event as @event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested event as @event' do
      event = Event.create!(valid_attributes)
      get :edit, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Event' do
        expect do
          post :create, params: { event: valid_attributes }
        end.to change(Event, :count).by(1)
      end

      it 'redirects to the events list' do
        post :create, params: { event: valid_attributes }
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Event' do
        expect do
          post :create, params: { event: invalid_attributes }
        end.not_to change(Event, :count)
      end

      it 're-renders the "new" template' do
        post :create, params: { event: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    let(:event) { Event.create!(valid_attributes) }

    context 'with valid params' do
      let(:new_attributes) { { name: 'New Event Name' } }

      it 'updates the requested event' do
        put :update, params: { id: event.id, event: new_attributes }
        event.reload
        expect(event.name).to eq('New Event Name')
      end

      it 'redirects to the event list' do
        put :update, params: { id: event.id, event: new_attributes }
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid params' do
      it 'does not update the event' do
        put :update, params: { id: event.id, event: invalid_attributes }
        event.reload
        expect(event.name).not_to eq('')
      end

      it 're-renders the "edit" template' do
        put :update, params: { id: event.id, event: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      event = Event.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: event.id }
      end.to change(Event, :count).by(-1)
    end

    it 'redirects to the events list' do
      event = Event.create!(valid_attributes)
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(events_url)
    end
  end
end
