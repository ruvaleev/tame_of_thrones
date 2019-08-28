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

  describe '#greeting' do
    let(:kingdom) { create(:kingdom) }
    let(:vassal) { create(:kingdom, sovereign: kingdom) }
    let(:enemy) { create(:kingdom) }
    let(:neutral) { create(:kingdom) }
    let!(:message) { create(:message, sender: enemy, receiver: kingdom) }

    let(:ally_response) { instance_double(Response) }
    let(:enemy_response) { instance_double(Response) }
    let(:neutral_response) { instance_double(Response) }

    before do
      allow(Response).to receive(:new).with(kingdom, vassal, 'ally_greeting').and_return(ally_response)
      allow(ally_response).to receive(:send).and_return('some ally greeting')

      allow(Response).to receive(:new).with(kingdom, enemy, 'enemy_greeting').and_return(enemy_response)
      allow(enemy_response).to receive(:send).and_return('some enemy greeting')

      allow(Response).to receive(:new).with(kingdom, neutral, 'neutral_greeting').and_return(neutral_response)
      allow(neutral_response).to receive(:send).and_return('some neutral greeting')
    end

    it 'sends ally_greeting messages to allies' do
      expect(kingdom.greeting(vassal)).to eq 'some ally greeting'
    end

    it 'sends enemy_greeting messages to enemies' do
      expect(kingdom.greeting(enemy)).to eq 'some enemy greeting'
    end

    it 'sends neutral_greeting messages to neutrals' do
      expect(kingdom.greeting(neutral)).to eq 'some neutral greeting'
    end
  end
end
