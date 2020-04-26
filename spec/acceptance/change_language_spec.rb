# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Change language', '
  In order to change language
  As User
  I want to be able to change current locale
' do
  scenario 'lang_panel is hidden' do
    visit root_path
    expect(page).not_to have_css('.lang_panel', visible: true)
  end
  scenario "after click on 'tunes' button lang_panel is shown", js: true do
    visit root_path
    find('#tunes').click
    expect(page).to have_css('.lang_panel', visible: true)
  end

  context 'when current locale :en' do
    before { visit root_path(locale: 'en') }

    scenario 'en is not active link' do
      expect(page).not_to have_link('en')
    end
    scenario 'ru is active link and changes locale to :ru' do
      expect(page).to have_link('ru', href: root_path(locale: :ru))
    end
  end

  context 'when current locale :ru' do
    before { visit root_path(locale: 'ru') }

    scenario 'ru is not active link' do
      expect(page).not_to have_link('ru')
    end
    scenario 'en is active link and changes locale to :en' do
      expect(page).to have_link('en', href: root_path(locale: :en))
    end
  end
end
