require 'rails_helper'

RSpec.describe KingdomsController, type: :controller do
  describe 'GET #index' do
    let(:kingdoms) { create_list(:kingdom, 3) }
    let(:space_kingdom) { create(:kingdom, name: 'Space') }
    let!(:vassal) { create(:kingdom, sovereign: space_kingdom) }
    before { get :index }

    it 'populates an array of all kingdoms' do
      expect(assigns(:kingdoms)).to match_array(kingdoms.concat([space_kingdom, vassal]))
    end

    it "populates an array of all Kingdom Space's vassals" do
      expect(assigns(:allies)).to match_array([vassal])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

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
