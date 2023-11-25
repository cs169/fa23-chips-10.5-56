# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let(:google_auth_mock) do
    {
      'provider' => 'google_oauth2',
      'uid'      => '123456789',
      'info'     => {
        'first_name' => 'Leah',
        'last_name'  => 'Wang',
        'email'      => 'leahwang61@berkeley.edu'
      }
    }
  end

  let(:github_auth_mock) do
    {
      'provider' => 'github',
      'uid'      => '987654321',
      'info'     => {
        'name'  => 'Leah Wang',
        'email' => 'leahwang61@berkeley.edu'
      }
    }
  end

  describe 'GET #login' do
    it 'renders the login page' do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe 'POST #google_oauth2' do
    before do
      request.env['omniauth.auth'] = google_auth_mock
      post :google_oauth2
    end

    it 'creates a new user session' do
      expect(session[:current_user_id]).not_to be_nil
    end

    it 'redirects to the destination url or root url' do
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'POST #github' do
    before do
      request.env['omniauth.auth'] = github_auth_mock
      post :github
    end

    it 'creates a new user session' do
      expect(session[:current_user_id]).not_to be_nil
    end

    it 'redirects to the destination url or root url' do
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'POST #logout' do
    before do
      session[:current_user_id] = 1
      post :logout
    end

    it 'destroys the user session' do
      expect(session[:current_user_id]).to be_nil
    end

    it 'redirects to the root path' do
      expect(response).to redirect_to(root_path)
    end
  end
end
