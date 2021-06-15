require 'rails_helper'

require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_missing.rb')

describe Api::V1::UsersController, :type => :controller do

  let(:user) { create :user }

  describe 'GET /api/v1/users/:user_id' do
    context 'when the user exists' do
      before do
        header 'api-key', user.api_token
        get "/api/v1/users/#{user.id}"
      end

      it 'should return the user' do
        expect(json['user']).not_to be_empty
        expect(json['user']['id']).to eq(user.id)
        expect(json['user']['username']).to eq(user.name)
      end
    end

    context 'when the user does not exist' do
      it_behaves_like "respond to missing", '/api/v1/users/-1'
    end
  end

  describe 'GET /api/v1/users' do
    context 'when the user exists' do
      before do
        header 'api-key', user.api_token
        get "/api/v1/users"
      end

      it 'should return the user' do
        expect(json['user']).not_to be_empty
        expect(json['user']['id']).to eq(user.id)
        expect(json['user']['username']).to eq(user.name)
        expect(json['user']['email']).to eq(user.email)
      end
    end
  end



end
