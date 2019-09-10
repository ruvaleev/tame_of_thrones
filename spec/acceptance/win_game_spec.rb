require_relative 'acceptance_helper'

feature 'Sounds panel use', '
  In order to read rules or manage sounds
  As User
  I want to be able use sounds panel
' do

  let!(:ruler) { create(:kingdom, name: 'Space') }
  let!(:vassals) { create_list(:kingdom, 2, sovereign: ruler) }
  let!(:kingdoms) { create_list(:kingdom, 3) }

  before do
    visit root_path
    find(".kingdoms img[data-name=#{kingdoms.first.name}]").click
    fill_in 'body', with: correct_message_to(kingdoms.first)
    click_on 'Send'
  end

  scenario 'user sees final window', js: true do
    expect(page).to have_selector('#throne_is_taken', visible: true)
  end

  scenario 'empty throne became color throne', js: true do
    within '.throne' do
      expect(page).to have_selector('#throne')
    end
  end

  scenario "user can see ruler king's name near throne", js: true do
    within '.throne' do
      expect(page).to have_text(ruler.king)
    end
  end

  scenario "user can see ruler kingdom's name near throne", js: true do
    within '.throne' do
      expect(page).to have_text(ruler.name)
    end
  end
end
