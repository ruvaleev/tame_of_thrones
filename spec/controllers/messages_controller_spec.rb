# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let!(:sender) { create(:kingdom, name_en: 'Space') }
  let(:receiver) { create(:kingdom) }

  describe 'POST #create' do
    let(:body) { 'Some message body' }

    it 'creates new message' do
      expect do
        post :create, params: { sender_id: sender, receiver_id: receiver, body: body }, format: :json
      end.to change(Message, :count).by(1)
    end

    it 'returns success' do
      post :create, params: { sender_id: sender, receiver_id: receiver, body: body }, format: :json
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
