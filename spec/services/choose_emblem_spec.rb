# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseEmblem do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(game_set.id) }
  let(:game_set) { create(:game_set) }
  let(:kingdom_for_this_game_set) { create(:kingdom, game_set: game_set, emblem_en: 'Gorilla', emblem_ru: 'Горилла') }
  let(:kingdom_for_another_game_set) { create(:kingdom, emblem_en: 'Gorilla', emblem_ru: 'Горилла') }
  let(:emblems_double) { [emblem_en: 'Gorilla', emblem_ru: 'Горилла'] }

  before { stub_const('ChooseEmblem::EMBLEMS', emblems_double) }

  it 'returns response kind of hash with keys :en, :ru' do
    response = run_service
    expect(
      %i[en ru].map { |locale| response.keys.include?(locale) }.uniq
    ).to eq [true]
  end
  it 'looking for uniq emblems for current game_set' do
    kingdom_for_this_game_set
    expect { Timeout.timeout(0.01) { run_service } }.to raise_error(Timeout::Error)
  end
  it 'allows not uniq emblems for different game_sets' do
    kingdom_for_another_game_set
    expect { Timeout.timeout(0.01) { run_service } }.not_to raise_error(Timeout::Error)
  end
end
