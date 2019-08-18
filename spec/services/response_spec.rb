# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response do
  let(:sender) { create(:kingdom) }
  let(:receiver) { create(:kingdom) }

  subject { described_class.new(sender, receiver, response) }

  before do
    subject.stub(:choose_response) { '%{receiver_name}% %{receiver_king}% %{sender_name}% %{sender_king}%'.dup }
  end

  describe '#send' do
    context 'consent messages' do
      let(:response) { 'consent' }

      it 'transforms parameters in string to correct values' do
        expect(subject.send).to eq "#{receiver.name} #{receiver.king} #{sender.name} #{sender.king}"
      end
    end
  end
end
