# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateKingdom do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(game_set.id) }
  let(:game_set) { create(:game_set) }

  it 'creates kingdom for provided game_set' do
    expect { run_service }.to change(game_set.kingdoms, :count).by(1)
  end
  context 'when :save parameter set to true (by default)' do
    let(:service) { described_class.new(game_set.id, true) }

    it 'returns saved kingdom' do
      kingdom = run_service
      expect(kingdom.persisted?).to be_truthy
    end
  end
  context 'when :player parameter set to false (by default)' do
    let(:service) { described_class.new(game_set.id, false) }

    it 'returns not player kingdom' do
      kingdom = run_service
      expect(kingdom.game_id).to be nil
    end
  end
  context 'when :player parameter set to true' do
    let(:service) { described_class.new(game_set.id, true) }
    let(:kingdom) { run_service }

    it 'returns player kingdom with :game_id equal to game_set.id' do
      expect(kingdom.game_id).to eq game_set.id
    end
    it 'player kingdom has game set equal to game_set.id' do
      expect(kingdom.game_set_id).to eq game_set.id
    end
    it 'player kingdom has game set equal to game_set.id' do
      expect(kingdom.game_set_id).to eq game_set.id
    end
    it 'player kingdom has no leader_avatar' do
      expect(kingdom.leader_avatar).to be nil
    end
    it 'player kingdom has no emblem_avatar' do
      expect(kingdom.emblem_avatar).to be nil
    end
  end
end
