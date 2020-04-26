# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Reload game', '
  In order to reload the game
  As User
  I want to be able to recreate every kingdom with one button click
' do
  let(:sovereign) { create(:kingdom, name: 'Space') }
  let!(:vassals) { create_list(:kingdom, 2, sovereign: sovereign) }

  before do
    enter_game(sleep_timer: 1)
    find('#reload_button').click
  end

  scenario 'after button pushed no green cells left on the circle', js: true do
    expect(page).to_not have_selector('img.light_cell.green', visible: true)
  end
  scenario "after button pushed no one old kingdom's left", js: true do
    expect(page).to_not have_selector("img.emblem[data-id=\'#{vassals.sample.id}\']", visible: true)
  end
end
