require_relative 'acceptance_helper'

feature 'Create alliances', '
  In order to create an alliance
  As King Shan
  I want to send messages to possible allies
' do
  let!(:sender_kingdom) { create(:kingdom, name: 'Space') }
  let!(:kingdom_receiver) { create(:kingdom) }
  let(:correct_message) { correct_message_to(kingdom_receiver) }

  before do
    visit root_path
    find(".kingdoms img[data-name=#{kingdom_receiver.name}]").click
  end

  scenario 'opens dialogue window', js: true do
    expect(page).to have_selector('.dialogue_window', visible: true)
  end

  context 'when sends correct message', js: true do
    before do
      fill_in 'body', with: correct_message
      click_on 'Send'
    end
    scenario 'see message in chat window' do
      within '#chat' do
        expect(page).to have_text correct_message
      end
    end
    scenario 'new alliance is created' do
      expect(sender_kingdom.vassals).to eq [kingdom_receiver]
    end
    scenario "see receiver's emblem in Allies window" do
      within '#allies' do
        expect(page).to have_selector("img[data-name=#{kingdom_receiver.name}]")
      end
    end
  end

  context 'when sends incorrect message', js: true do
    let(:incorrect_message) { incorrect_message_to(kingdom_receiver) }

    before do
      fill_in 'body', with: incorrect_message
      click_on 'Send'
    end
    scenario 'see message in chat window' do
      within '#chat' do
        expect(page).to have_text incorrect_message
      end
    end
    scenario 'new alliance is not created' do
      expect(sender_kingdom.vassals).to_not eq [kingdom_receiver]
    end
    scenario "can't see receiver's emblem in Allies window" do
      within '#allies' do
        expect(page).to_not have_selector("img[data-name=#{kingdom_receiver.name}]")
      end
    end
  end

  context 'when reset', js: true do
    before do
      fill_in 'body', with: correct_message
      click_on 'Send'
    end

    context 'alliances' do
      before { find('#allies_reset_button').click }
      scenario 'sender kingdom have no vassals' do
        expect(sender_kingdom.vassals).to eq []
      end

      scenario 'receiver kingdom have no sovereign' do
        expect(kingdom_receiver.sovereign).to eq nil
      end

      scenario 'Allies window is empty' do
        within '#allies' do
          expect(page).to_not have_selector('img')
        end
      end
    end
  end
end
