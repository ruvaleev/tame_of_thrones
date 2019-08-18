require 'rails_helper'

RSpec.describe KingdomsController, type: :controller do
  describe 'POST #reset_alliances' do
    let!(:messages) { create_list(:message, 5) }
    let!(:sovereign) { create(:kingdom, ruler: true) }
    let!(:vassals) { create_list(:kingdom, 3, sovereign: sovereign) }

    subject { post :reset_alliances }

    it 'destroys all messages' do
      expect { subject }.to change(Message, :count).from(5).to(0)
    end

    it 'nullifies sovereign_id for all kingdoms' do
      expect { subject }.to change { Kingdom.all.pluck(:sovereign_id).compact.uniq }.from([sovereign.id]).to([])
    end

    it 'nullifies ruler field for all kingdoms' do
      expect { subject }.to change { sovereign.reload.ruler }.from(true).to(false)
    end
  end
end
