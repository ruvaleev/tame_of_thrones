# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Win game', '
  In order to see I won
  As User
  I want to be able to see appropriate message
' do
  let(:game_set) { create(:game_set) }
  let!(:player) { create(:player, game: game_set) }
  let!(:vassals) { create_list(:kingdom, 2, sovereign: player, game_set: game_set) }
  let!(:kingdoms) { create_list(:kingdom, 4, game_set: game_set) }

  before do
    enter_game(sleep_timer: 0.5, game_set_uid: game_set.uid)
    send_message(kingdoms.first.id, correct_message_to(kingdoms.first))
  end

  scenario 'user sees final window', js: true do
    expect(page).to have_selector('#throne_is_taken', visible: true)
  end

  scenario "user can see ruler king's name", js: true do
    within '#circle' do
      expect(page).to have_text(player.leader.upcase)
    end
  end

  scenario "user can see ruler kingdom's name", js: true do
    within '#circle' do
      expect(page).to have_text(player.name)
    end
  end
end
