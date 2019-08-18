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
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:emblem) }
  it { should validate_presence_of(:king) }

  let(:kingdom_sender) { create(:kingdom) }
  let(:kingdom_receiver) { create(:kingdom) }
  let(:message_text) { FFaker::Lorem.sentence }

  describe '#ask_allegiance' do
    context "message containing receiver's emblem" do
      let(:correct_message) do
        message_text[rand(message_text.length - 1)] = kingdom_receiver.emblem.split('').sort_by { rand }.join
        message_text
      end

      let(:ask_for_allegiance) { kingdom_sender.ask_for_allegiance(kingdom_receiver, correct_message) }

      it 'creates new message' do
        expect { ask_for_allegiance }.to change(Message, :count).by(1)
      end

      it "receiver becames a sender's vassal" do
        expect { ask_for_allegiance }.to change(kingdom_sender.vassals, :count).by(1)
      end

      it "sender becames a receiver's sovereign" do
        expect { ask_for_allegiance }.to change(kingdom_receiver, :sovereign_id).from(nil).to(kingdom_sender.id)
      end
    end

    context "message not containing receiver's emblem" do
      let(:incorrect_message) do
        message = FFaker::Lorem.sentence
        message.delete(kingdom_receiver.emblem.last)
      end

      let(:ask_for_allegiance) { kingdom_sender.ask_for_allegiance(kingdom_receiver, incorrect_message) }

      it 'creates new message' do
        expect { ask_for_allegiance }.to change(Message, :count).by(1)
      end

      it "receiver doesn't became a sender's vassal" do
        expect { ask_for_allegiance }.to_not change(kingdom_sender.vassals, :count)
      end

      it "sender doesn't became a receiver's sovereign" do
        expect { ask_for_allegiance }.to_not change(kingdom_receiver, :sovereign_id)
      end
    end
  end

  describe '#prepare_message' do
    let(:prepare_message) { kingdom_sender.prepare_message(kingdom_receiver, message_text) }

    it 'creates new message' do
      expect { prepare_message }.to change(Message, :count).by(1)
    end

    it 'new message saves receiver' do
      message = prepare_message
      expect(message.receiver).to eq kingdom_receiver
    end

    it 'new message saves sender' do
      message = prepare_message
      expect(message.sender).to eq kingdom_sender
    end
  end
end
