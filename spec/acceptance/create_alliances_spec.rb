# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create alliances', '
  In order to create an alliance
  As King Shan
  I want to send messages to possible allies
' do
  let!(:sender_kingdom) { create(:kingdom, name_en: 'Space') }
  let!(:kingdom_receiver) { create(:kingdom) }
  let!(:second_receiver) { create(:kingdom) }
  let(:correct_message) { correct_message_to(kingdom_receiver) }
  let(:incorrect_message) { incorrect_message_to(kingdom_receiver) }

  before { enter_game(sleep_timer: 1) }

  scenario 'opens dialogue window and shows title of receiver', js: true do
    find(".circle img[data-id=\'#{kingdom_receiver.id}\']").click
    expect(page).to have_selector('.title', visible: true)
  end

  context 'when sends correct message', js: true do
    before { send_message(kingdom_receiver.id, correct_message) }
    scenario 'see message in chat window' do
      expect(page).to have_text correct_message
    end
    scenario 'new alliance is created' do
      expect(sender_kingdom.vassals).to eq [kingdom_receiver]
    end
    scenario "cell with receiver's emblem became green" do
      expect(page).to have_selector("img.light_cell.green[data-id=\'#{kingdom_receiver.id}\']", visible: true)
    end
    scenario 'cell remains green even after message to another kingdom sent' do
      send_message(second_receiver.id, correct_message)
      expect(page).to have_selector("img.light_cell.green[data-id=\'#{kingdom_receiver.id}\']", visible: true)
    end
    scenario "cell with receiver's emblem remains green after page reloading" do
      enter_game
      expect(page).to have_selector("img.light_cell.green[data-id=\'#{kingdom_receiver.id}\']", visible: true)
    end
    scenario 'inner green highlight turns on' do
      expect(page).to have_selector('img#green_light_inner', visible: true)
    end
    scenario 'outer green highlight turns on' do
      expect(page).to have_selector('img#green_light_outer', visible: true)
    end
  end

  context 'when sends incorrect message', js: true do
    before { send_message(kingdom_receiver.id, incorrect_message) }
    scenario 'see message in chat window' do
      within '#chat' do
        expect(page).to have_text incorrect_message
      end
    end
    scenario 'new alliance is not created' do
      expect(sender_kingdom.vassals).to_not eq [kingdom_receiver]
    end
    scenario "cell with receiver's emblem became red" do
      expect(page).to have_selector("img.light_cell.red[data-id=\'#{kingdom_receiver.id}\']", visible: true)
    end
    scenario "cell doesn't remain red in two seconds after message sent" do
      sleep(2)
      expect(page).not_to have_selector("img.light_cell.red[data-id=\'#{kingdom_receiver.id}\']", visible: true)
    end
    scenario 'inner red highlight turns on' do
      expect(page).to have_selector('img#red_light_inner', visible: true)
    end
    scenario 'outer red highlight turns on' do
      expect(page).to have_selector('img#red_light_outer', visible: true)
    end
  end
end
