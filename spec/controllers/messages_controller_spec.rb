require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'GET #greeting' do
    let!(:sender) { create(:kingdom, name: 'Space') }
    let(:receiver) { create(:kingdom) }

    it 'returns greeting from receiver to sender' do
      get :greeting, params: { receiver_id: receiver }, format: :json
      expect(response).to be_success
    end
  end
end
