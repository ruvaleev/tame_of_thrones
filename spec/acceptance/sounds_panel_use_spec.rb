# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Sounds panel use', '
  In order to manage sounds
  As User
  I want to be able to use sounds panel
' do
  let!(:sender_kingdom) { create(:kingdom, name: 'Space') }

  before { visit root_path }

  scenario 'sounds_off button shown after click on sounds_on button', js: true do
    find('#sounds_on').click
    expect(page).to have_selector('#sounds_off', visible: true)
  end

  scenario 'sounds_on button shown after click on sounds_off button', js: true do
    find('#sounds_on').click
    find('#sounds_off').click
    expect(page).to have_selector('#sounds_on', visible: true)
  end

  scenario 'music_off button shown after click on click on music_on button', js: true do
    find('#music_on').click
    expect(page).to have_selector('#music_off', visible: true)
  end

  scenario 'music_on button shown after click on click on music_off button', js: true do
    find('#music_on').click
    find('#music_off').click
    expect(page).to have_selector('#music_on', visible: true)
  end
end
