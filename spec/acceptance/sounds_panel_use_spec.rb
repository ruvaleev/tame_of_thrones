require_relative 'acceptance_helper'

feature 'Sounds panel use', '
  In order to read rules or manage sounds
  As User
  I want to be able use sounds panel
' do

  let!(:sender_kingdom) { create(:kingdom, name: 'Space') }

  before { visit root_path }

  scenario 'click on sounds_on button', js: true do
    find('#sounds_on').click
    expect(page).to have_selector('#sounds_off', visible: true)
  end

  scenario 'click on sounds_off button', js: true do
    find('#sounds_on').click
    find('#sounds_off').click
    expect(page).to have_selector('#sounds_on', visible: true)
  end

  scenario 'click on music_on button', js: true do
    find('#music_on').click
    expect(page).to have_selector('#music_off', visible: true)
  end

  scenario 'click on music_off button', js: true do
    find('#music_on').click
    find('#music_off').click
    expect(page).to have_selector('#music_on', visible: true)
  end

  scenario 'click on rules button', js: true do
    find('#rules').click
    expect(page).to have_selector('#rules_modal', visible: true)
  end

  scenario 'click on rules button', js: true do
    find('#rules').click
    expect(page).to have_selector('#rules_modal', visible: true)
  end

  scenario 'click on bacground of modal window with rules', js: true do
    find('#rules').click
    find('#rules_modal').click
    expect(page).to have_selector('#rules_modal', visible: true)
  end
end
