# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseLeaderAvatar do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(:King, game_set.id) }
  let(:game_set) { create(:game_set) }
  let(:avatar_id) { rand(9) }
  let(:existing_leader_avatar) { "king_avatars/#{avatar_id}.png" }
  let(:kingdom_for_this_game_set) { create(:kingdom, game_set: game_set, leader_avatar: existing_leader_avatar) }
  let(:kingdom_for_another_game_set) { create(:kingdom, leader_avatar: existing_leader_avatar) }
  let(:avatars_titles_double) { { King: [avatar_id] } }

  before { stub_const('ChooseLeaderAvatar::AVATARS_TITLES', avatars_titles_double) }

  it 'returns avatar_id' do
    expect(run_service).to eq avatar_id
  end
  it 'looking for uniq avatars for current game_set' do
    kingdom_for_this_game_set
    expect { Timeout.timeout(0.01) { run_service } }.to raise_error(Timeout::Error)
  end
  it 'allows not uniq avatars for different game_sets' do
    kingdom_for_another_game_set
    expect { Timeout.timeout(0.01) { run_service } }.not_to raise_error(Timeout::Error)
  end
end
