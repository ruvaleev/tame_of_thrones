# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameSetsController, type: :controller do
  let(:game_set) { create(:game_set) }

  describe 'GET #preload' do
    subject(:send_request) { get :preload }

    context 'when game set is absent' do
      it 'creates new game_set' do
        expect { send_request }.to change(GameSet, :count).by(1)
      end

      it 'assigns new player to @player' do
        send_request
        expect(assigns(:player)).to be_kind_of(Kingdom)
      end

      it 'assigns game_set kingdom to @game_set' do
        allow(GameSet).to receive(:create).and_return(game_set)
        send_request
        expect(assigns(:game_set)).to eq game_set
      end

      it "assigns game_set's :uid to cookies[:tot_game_set]" do
        allow(GameSet).to receive(:create).and_return(game_set)
        expect { send_request }.to change { cookies[:tot_game_set] }.from(nil).to(game_set.uid)
      end

      it 'creates 7 new kingdoms' do
        expect { send_request }.to change(Kingdom, :count).by(7)
      end
    end

    context 'when game set is created and user has its uid in cookies' do
      let!(:player) { create(:player, game_id: game_set.id) }

      before { cookies[:tot_game_set] = game_set.uid }

      it "doesn't create new game_set" do
        expect { send_request }.not_to change(GameSet, :count)
      end

      it "assigns game_set's player to @player" do
        send_request
        expect(assigns(:player)).to eq player
      end
    end
  end

  describe 'GET #index' do
    let(:kingdoms) { create_list(:kingdom, 6, game_set: game_set) }
    let!(:player) { create(:player, game_set: game_set) }
    let!(:vassal) do
      kingdom = kingdoms.sample
      kingdom.update(sovereign: player)
      kingdom
    end

    before { get :index, params: { game_set_id: game_set.id }, format: :js }

    it 'populates an array of all kingdoms' do
      expect(assigns(:kingdoms)).to match_array(kingdoms)
    end

    it "assigns game_set's player to @player" do
      expect(assigns(:player)).to eq player
    end

    it "populates an array of all Kingdom Space's vassals" do
      expect(assigns(:allies_ids)).to match_array([vassal.id])
    end
  end

  describe 'POST #reset_player' do
    subject(:send_request) { post :reset_player, params: { game_set_id: game_set.id }, format: :json }

    let!(:player) { create(:player, game_set: game_set) }

    it 'creates another player for game_set' do
      expect { send_request }.to change { game_set.reload.player }.from(player)
    end
    it "assigns game_set's player to @player" do
      send_request
      expect(assigns(:player)).to eq game_set.reload.player
    end
  end
end
