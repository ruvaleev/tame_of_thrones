# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Kingdom do
  it { should belong_to(:sovereign).class_name('Kingdom').optional }
  it do
    should have_many(:vassals).class_name('Kingdom').with_foreign_key('sovereign_id')
      .inverse_of(:sovereign).dependent(:nullify)
  end
  it do
    should have_many(:sent_messages).class_name('Message').with_foreign_key('sender_id')
      .inverse_of(:sender).dependent(:destroy)
  end
  it do
    should have_many(:received_messages).class_name('Message').with_foreign_key('receiver_id')
      .inverse_of(:receiver).dependent(:nullify)
  end

  let(:kingdom) { create(:kingdom) }
  let(:lion_kingdom) { create(:kingdom, emblem: 'Lion') }
  let(:message_text) { FFaker::Lorem.sentence }

  describe '#ask_allegiance' do
    context "message containing receiver's emblem" do
      let(:correct_message) do
        message_text[rand(message_text.length - 1)] = lion_kingdom.emblem.split('').sort_by { rand }.join
        message_text
      end

      let(:ask_for_allegiance) { kingdom.ask_for_allegiance(lion_kingdom, correct_message) }

      it 'creates new message' do
        expect { ask_for_allegiance }.to change(Message, :count).by(1)
      end

      it "receiver becames a sender's vassal" do
        expect { ask_for_allegiance }.to change(kingdom.vassals, :count).by(1)
      end

      it "sender becames a receiver's sovereign" do
        expect { ask_for_allegiance }.to change(lion_kingdom, :sovereign_id).from(nil).to(kingdom.id)
      end
    end

    context "message not containing receiver's emblem" do
      let(:incorrect_message) do
        message = FFaker::Lorem.sentence
        message.delete(lion_kingdom.emblem.last)
      end

      let(:ask_for_allegiance) { kingdom.ask_for_allegiance(lion_kingdom, incorrect_message) }

      it 'creates new message' do
        expect { ask_for_allegiance }.to change(Message, :count).by(1)
      end

      it "receiver doesn't became a sender's vassal" do
        expect { ask_for_allegiance }.to_not change(kingdom.vassals, :count)
      end

      it "sender doesn't became a receiver's sovereign" do
        expect { ask_for_allegiance }.to_not change(lion_kingdom, :sovereign_id)
      end
    end
  end

  describe '#prepare_message' do
    let(:prepare_message) { kingdom.prepare_message(lion_kingdom, message_text) }

    it 'creates new message' do
      expect { prepare_message }.to change(Message, :count).by(1)
    end

    it 'new message saves receiver' do
      message = prepare_message
      expect(message.receiver).to eq lion_kingdom
    end

    it 'new message saves sender' do
      message = prepare_message
      expect(message.sender).to eq kingdom
    end
  end
end
