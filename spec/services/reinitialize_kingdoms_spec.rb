# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReinitializeKingdoms do
  describe '#run' do
    context 'when no one kingdoms' do
      before { described_class.run }

      Kingdom::GREAT_HOUSES.each do |kingdom|
        it "creates #{kingdom[:name]} kingdom" do
          expect(Kingdom.where(name: kingdom[:name]).exists?).to be_truthy
        end
      end

      it 'creates only great houses' do
        expect(Kingdom.count).to eq Kingdom::GREAT_HOUSES.count
      end
    end

    context 'when there are kingdoms.already' do
      let!(:old_kingdoms) { create_list(:kingdom, 10) }

      it 'destroys old kingdoms' do
        expect { described_class.run }.to change(Kingdom, :count).from(10).to(6)
      end
    end
  end
end
