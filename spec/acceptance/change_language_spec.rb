# frozen_string_literal: true

require_relative 'acceptance_helper'

RSpec.shared_examples 'language_panel' do
  context 'when current locale :en', js: true do
    before { en_before_action }

    scenario 'en is not active link' do
      expect(page).not_to have_link('en')
    end
    scenario 'ru is active link and changes locale to :ru', js: true do
      expect(page).to have_link('ru', href: root_path(locale: :ru))
    end
  end

  context 'when current locale :ru', js: true do
    before { ru_before_action }

    scenario 'ru is not active link' do
      expect(page).not_to have_link('ru')
    end
    scenario 'en is active link and changes locale to :en' do
      expect(page).to have_link('en', href: root_path(locale: :en))
    end
  end
end

feature 'Change language', '
  In order to change language
  As User
  I want to be able to change current locale
' do
  context 'when preload page' do
    it_behaves_like 'language_panel' do
      let(:en_before_action) { visit root_path(locale: 'en') }
      let(:ru_before_action) { visit root_path(locale: 'ru') }
    end
  end
  scenario 'lang_panel is hidden', js: true do
    enter_game
    expect(page).not_to have_css('.lang_panel', visible: true)
  end
  scenario "after click on 'tunes' button lang_panel is shown", js: true do
    enter_game
    find('#tunes').click
    expect(page).to have_css('.lang_panel', visible: true)
  end
  it_behaves_like 'language_panel' do
    let(:en_before_action) { enter_game(locale: 'en') }
    let(:ru_before_action) { enter_game(locale: 'ru') }
  end
end
