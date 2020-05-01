# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseLeaderName do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(title, game_set.id) }
  let(:title) { %w[King Queen].sample }
  let(:existing_names) { 'Существующее имя, Existing name' }
  let(:game_set) { create(:game_set) }
  let(:kingdom_in_game_set) { create(:kingdom, leader_en: existing_names.split(', ').last, game_set: game_set) }
  let(:kingdom_in_another_game_set) { create(:kingdom, leader_en: existing_names.split(', ').last) }

  it 'returns response kind of hash with keys :en and :ru' do
    response = run_service
    expect(
      %i[en ru].map { |locale| response.keys.include?(locale) }.uniq
    ).to eq [true]
  end
  it 'looking for uniq names in scope of game set' do
    kingdom_in_game_set
    allow(File).to receive(:read).and_return(existing_names)
    expect { Timeout.timeout(0.01) { run_service } }.to raise_error(Timeout::Error)
  end
  it 'allows non uniq names in different game sets' do
    kingdom_in_another_game_set
    allow(File).to receive(:read).and_return(existing_names)
    expect { Timeout.timeout(0.01) { run_service } }.not_to raise_error(Timeout::Error)
  end
end
