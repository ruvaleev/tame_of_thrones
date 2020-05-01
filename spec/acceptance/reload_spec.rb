# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Reload game', '
  In order to reload the game
  As User
  I want to be able to recreate every kingdom with one button click
' do
  let(:game_set) { create(:game_set) }
  let(:player) { create(:player, game: game_set) }
  let!(:vassals) { create_list(:kingdom, 6, sovereign: player) }

  before do
    enter_game(sleep_timer: 1, game_set_uid: game_set.uid)
    find('#reload_button').click
  end

  scenario 'after button pushed no green cells left on the circle', js: true do
    expect(page).to_not have_selector('img.light_cell.green', visible: true)
  end
  scenario "after button pushed no one old kingdom's left", js: true do
    expect(page).to_not have_selector("img.emblem[data-id=\'#{vassals.sample.id}\']", visible: true)
  end
end
