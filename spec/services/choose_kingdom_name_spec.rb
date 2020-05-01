# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseKingdomName do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(game_set.id) }
  let(:game_set) { create(:game_set) }
  let(:existing_names) { 'Существующее имя, Existing name' }
  let(:kingdom_for_this_game_set) { create(:kingdom, game_set: game_set, name_en: existing_names.split(', ').last) }
  let(:kingdom_for_another_game_set) { create(:kingdom, name_en: existing_names.split(', ').last) }

  it 'returns response kind of hash with keys :en and :ru' do
    response = run_service
    expect(
      %i[en ru].map { |locale| response.keys.include?(locale) }.uniq
    ).to eq [true]
  end
  it 'looking for uniq names for current game_set' do
    kingdom_for_this_game_set
    allow(File).to receive(:read).and_return(existing_names)
    expect { Timeout.timeout(0.01) { run_service } }.to raise_error(Timeout::Error)
  end
  it 'allows not uniq names for different game_sets' do
    kingdom_for_another_game_set
    allow(File).to receive(:read).and_return(existing_names)
    expect { Timeout.timeout(0.01) { run_service } }.not_to raise_error(Timeout::Error)
  end
end
