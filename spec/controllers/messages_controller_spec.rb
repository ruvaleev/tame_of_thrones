# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:game_set) { create(:game_set) }
  let!(:player) { create(:kingdom, game: game_set) }
  let(:receiver) { create(:kingdom, game_set: game_set) }

  describe 'POST #create' do
    let(:body) { 'Some message body' }

    it 'creates new message' do
      expect do
        post :create, params: { receiver_id: receiver, body: body }, format: :json
      end.to change(Message, :count).by(1)
    end

    it 'returns success' do
      post :create, params: { receiver_id: receiver, body: body }, format: :json
      expect(response).to be_success
    end
  end

  describe 'GET #greeting' do
    it 'returns success' do
      get :greeting, params: { receiver_id: receiver }, format: :json
      expect(response).to be_success
    end
  end
end
