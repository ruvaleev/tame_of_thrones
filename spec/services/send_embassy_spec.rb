# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendEmbassy do
  let(:kingdom) { create(:kingdom) }
  let(:lion_kingdom) { create(:kingdom, emblem: 'Lion') }
  let(:message) { create(:message, sender: kingdom, receiver: lion_kingdom) }
  let(:send_embassy) { described_class.new(message) }

  describe '#ask_for_allegiance' do
    context "message containing receiver's emblem" do
      before { message.update(body: message.body.concat(lion_kingdom.emblem.split('').sort_by { rand }.join)) }

      it "receiver becames a sender's vassal" do
        expect { send_embassy.ask_for_allegiance }.to change(kingdom.vassals, :count).by(1)
      end

      it "sender becames a receiver's sovereign" do
        expect { send_embassy.ask_for_allegiance }.to change(lion_kingdom, :sovereign_id).from(nil).to(kingdom.id)
      end
    end

    context "message containing receiver's emblem" do
      before { message.update(body: message.body.delete(lion_kingdom.emblem.last)) }

      it "receiver doesn't became a sender's vassal" do
        expect { send_embassy.ask_for_allegiance }.to_not change(kingdom.vassals, :count)
      end

      it "sender doesn't became a receiver's sovereign" do
        expect { send_embassy.ask_for_allegiance }.to_not change(lion_kingdom, :sovereign_id)
      end
    end
  end
end
