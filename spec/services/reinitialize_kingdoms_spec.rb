# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReinitializeKingdoms do
  describe '#run' do
    context 'when no one kingdoms' do
      before { described_class.run }

      Kingdom::GREAT_HOUSES.each do |kingdom|
        it "creates #{kingdom[:name_en]} kingdom" do
          expect(Kingdom.where(name_en: kingdom[:name_en]).exists?).to be_truthy
        end
      end

      it 'creates only great houses' do
        expect(Kingdom.count).to eq Kingdom::GREAT_HOUSES.count
      end

      it 'set :title to :king when got males avatar' do
        expect(males_avatars.map { |avatar_id| recognize_title_by_avatar(avatar_id) }.uniq).to eq ['king']
      end

      it 'set :title to :queen when got females avatar' do
        expect(females_avatars.map { |avatar_id| recognize_title_by_avatar(avatar_id) }.uniq).to eq ['queen']
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

private

def recognize_title_by_avatar(avatar_id)
  Kingdom.find_by(leader_avatar: "king_avatars/#{avatar_id}.png").title
end

def males_avatars
  ReinitializeKingdoms::AVATARS_TITLES.select { |_avatar_id, title| title == :king }.keys
end

def females_avatars
  ReinitializeKingdoms::AVATARS_TITLES.select { |_avatar_id, title| title == :queen }.keys
end
