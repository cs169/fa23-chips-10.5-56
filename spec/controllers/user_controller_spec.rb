# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'GET #profile' do
    context 'when user is logged in' do
      let(:user) do
        User.create!(provider: 1, uid: '123456', email: 'leahwang61@berkeley.edu', first_name: 'Leah',
                     last_name: 'Wang')
      end

      before do
        session[:current_user_id] = user.id
      end

      it 'assigns @user' do
        get :profile
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :profile
        expect(response).to redirect_to(login_url) # Replace 'login_url' with your actual login path
      end
    end
  end
end
