# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Win game', '
  In order to see I won
  As User
  I want to be able to see appropriate message
' do
  let!(:ruler) { create(:kingdom, name_en: 'Space') }
  let!(:vassals) { create_list(:kingdom, 2, sovereign: ruler) }
  let!(:kingdoms) { create_list(:kingdom, 3) }

  before do
    enter_game(sleep_timer: 0.5)
    send_message(kingdoms.first.id, correct_message_to(kingdoms.first))
  end

  scenario 'user sees final window', js: true do
    expect(page).to have_selector('#throne_is_taken', visible: true)
  end

  scenario "user can see ruler king's name", js: true do
    within '#circle' do
      expect(page).to have_text(ruler.leader.upcase)
    end
  end

  scenario "user can see ruler kingdom's name", js: true do
    within '#circle' do
      expect(page).to have_text(ruler.name)
    end
  end
end
