# frozen_string_literal: true

require_relative 'acceptance_helper'

RSpec.shared_examples 'sounds_panel' do |primary_selector|
  before { before_action }

  scenario 'sounds_off button shown after click on sounds_on button', js: true do
    within primary_selector do
      find('#sounds_on').click
      expect(page).to have_selector('#sounds_off', visible: true)
    end
  end

  scenario 'sounds_on button shown after click on sounds_off button', js: true do
    within primary_selector do
      find('#sounds_on').click
      find('#sounds_off').click
      expect(page).to have_selector('#sounds_on', visible: true)
    end
  end

  scenario 'music_off button shown after click on click on music_on button', js: true do
    within primary_selector do
      find('#music_on').click
      expect(page).to have_selector('#music_off', visible: true)
    end
  end

  scenario 'music_on button shown after click on click on music_off button', js: true do
    within primary_selector do
      find('#music_on').click
      find('#music_off').click
      expect(page).to have_selector('#music_on', visible: true)
    end
  end
end

feature 'Sounds panel use', '
  In order to manage sounds
  As User
  I want to be able to use sounds panel
' do
  context 'with preload page' do
    it_behaves_like 'sounds_panel', '.preload' do
      let(:before_action) { visit root_path }
    end
  end

  context 'with game page' do
    it_behaves_like 'sounds_panel', '.container' do
      let(:before_action) { enter_game(sleep_timer: 0.5) }
    end
  end
end
