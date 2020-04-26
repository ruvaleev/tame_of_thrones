# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Reset alliances', '
  In order to reset alliances
  As User
  I want to reset every alliance and nullify play field
' do
  let!(:sender_kingdom) { create(:kingdom, name: 'Space') }
  let!(:kingdom_receiver) { create(:kingdom) }
  let(:correct_message) { correct_message_to(kingdom_receiver) }

  before { enter_game(sleep_timer: 0.5) }

  context 'when reset', js: true do
    before do
      send_message(kingdom_receiver.id, correct_message)
      page.execute_script("minimize_circle($('.container div.circle')[0])")
    end

    context 'alliances' do
      before { find('#reset_button').click }
      scenario 'sender kingdom have no vassals' do
        expect(sender_kingdom.vassals).to eq []
      end

      scenario 'receiver kingdom have no sovereign' do
        expect(kingdom_receiver.sovereign).to eq nil
      end

      scenario 'circle has no green cells' do
        expect(page).to_not have_selector('img.light_cell.green', visible: true)
      end
    end
  end
end
