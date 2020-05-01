# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KingdomsController, type: :controller do
  describe 'POST #update' do
    subject(:send_request) { post :update, params: params, format: :js }

    let(:kingdom) { create(:kingdom, title_en: 'King', name_en: 'Name', leader_en: 'Leader') }
    let(:params) { { id: kingdom.id, kingdom: { title_en: 'Queen', name_en: 'New Name', leader_en: 'New Leader' } } }

    it "updates game_set kingdom's title" do
      expect { send_request }.to change { kingdom.reload.title_en }.from('King').to('Queen')
    end

    it "updates game_set kingdom's name" do
      expect { send_request }.to change { kingdom.reload.name_en }.from('Name').to('New Name')
    end

    it "updates game_set kingdom's leader" do
      expect { send_request }.to change { kingdom.reload.leader_en }.from('Leader').to('New Leader')
    end
  end
  describe 'POST #reset_alliances' do
    let(:game_set) { create(:game_set) }
    let!(:messages) { create_list(:message, 5, sender: player) }
    let!(:player) { create(:kingdom, ruler: true, game_set: game_set, game: game_set) }
    let!(:vassals) { create_list(:kingdom, 3, sovereign: player, game_set: game_set) }
    let!(:another_message) { create(:message, sender: another_player) }
    let!(:another_player) { create(:kingdom, ruler: true) }

    subject(:send_request) { post :reset_alliances, params: { id: game_set.id } }

    it 'destroys all messages in this game_set' do
      expect { send_request }.to change(player.sent_messages, :count).from(5).to(0)
    end

    it 'nullifies sovereign_id for all game_set kingdoms' do
      expect { send_request }.to change { game_set.kingdoms.pluck(:sovereign_id).compact.uniq }.from([player.id]).to([])
    end

    it 'nullifies ruler field for all game_set kingdoms' do
      expect { send_request }.to change { player.reload.ruler }.from(true).to(false)
    end

    it "doesn't affect another game_set player" do
      expect { send_request }.not_to change { another_player.reload.ruler } # rubocop:disable Lint/AmbiguousBlockAssociation
    end

    it "doesn't affect another game_set messages" do
      expect { send_request }.not_to change(another_player.sent_messages, :count)
    end
  end

  describe 'POST #reset_kingdoms' do
    let(:game_set) { create(:game_set) }
    let!(:messages) { create_list(:message, 5, sender: player) }
    let!(:player) { create(:kingdom, ruler: true, game_set: game_set, game: game_set) }
    let!(:vassals) { create_list(:kingdom, 6, sovereign: player, game_set: game_set) }
    let!(:another_message) { create(:message, sender: another_player) }
    let!(:another_player) { create(:kingdom, ruler: true) }

    subject(:send_request) { post :reset_kingdoms, params: { id: game_set.id }, format: :js }

    it 'destroys all messages in this game_set' do
      expect { send_request }.to change(player.sent_messages, :count).from(5).to(0)
    end

    it 'destroys old kingdoms' do
      expect { send_request }.to change { game_set.game_kingdoms.include?(vassals.sample) }.from(true).to(false)
    end

    it 'creates new kingdoms set for game_set' do
      expect { send_request }.not_to change { game_set.kingdoms.count } # rubocop:disable Lint/AmbiguousBlockAssociation
    end

    it 'populates an array of all game_set game_kingdoms' do
      send_request
      expect(assigns(:kingdoms)).to match_array(game_set.game_kingdoms)
    end

    it "doesn't affect another game_set messages" do
      expect { send_request }.not_to change(another_player.sent_messages, :count)
    end
  end
end
