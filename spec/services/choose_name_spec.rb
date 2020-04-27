# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChooseName do
  subject(:run_service) { service.run }

  let(:service) { described_class.new(title) }
  let(:title) { %w[king queen].sample }
  let(:uniq_names) { 'Тестовое имя, Test name' }
  let(:existing_names) { 'Существующее имя, Existing name' }
  let!(:kingdom) { create(:kingdom, leader_en: existing_names.split(', ').last) }

  it 'returns response kind of hash with keys :en and :ru' do
    response = run_service
    expect(
      %i[en ru].map { |locale| response.keys.include?(locale) }.uniq
    ).to eq [true]
  end
  it 'looking for uniq names' do
    allow(File).to receive(:read).and_return(existing_names)
    expect { Timeout.timeout(0.01) { run_service } }.to raise_error(Timeout::Error)
  end

  # When 'player' feature will be added, make scope by player_id
end
