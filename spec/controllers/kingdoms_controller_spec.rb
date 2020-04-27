# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KingdomsController, type: :controller do
  describe 'GET #preload' do
    before { get :preload }

    it 'returns success' do
      expect(response).to be_success
    end
  end
  describe 'GET #index' do
    let(:kingdoms) { create_list(:kingdom, 3) }
    let(:space_kingdom) { create(:kingdom, name_en: 'Space') }
    let!(:vassal) { create(:kingdom, sovereign: space_kingdom) }
    before { get :index, format: :js }

    it 'populates an array of all kingdoms' do
      expect(assigns(:kingdoms)).to match_array(kingdoms.concat([space_kingdom, vassal]))
    end

    it "populates an array of all Kingdom Space's vassals" do
      expect(assigns(:allies_ids)).to match_array([vassal.id])
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

  describe 'POST #reset_kingdoms' do
    let!(:messages) { create_list(:message, 5) }
    let!(:sovereign) { create(:kingdom, ruler: true) }
    let!(:vassals) { create_list(:kingdom, 9, sovereign: sovereign) }

    subject { post :reset_kingdoms, format: :js }

    it 'destroys all messages' do
      expect { subject }.to change(Message, :count).from(5).to(0)
    end

    it 'destroys old kingdoms' do
      subject
      expect(Kingdom.find_by(id: sovereign.id)).to be nil
    end

    it 'creates new kingdoms from Great Houses' do
      expect { subject }.to change { Kingdom.count }.to(6)
    end

    it 'populates an array of all kingdoms' do
      subject
      expect(assigns(:kingdoms)).to match_array(Kingdom.all)
    end
  end
end
