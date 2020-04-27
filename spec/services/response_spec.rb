# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response do
  let(:sender) { create(:kingdom) }
  let(:receiver) { create(:kingdom) }
  let(:response) { 'consent' }

  subject(:service) { described_class.new(sender, receiver, response) }

  before do
    service.stub(:choose_response) do
      '%{receiver_name}% %{sender_name}% %{receiver_king}% %{sender_king}% %{receiver_title}% %{sender_title}%'.dup
    end
  end

  describe '#send' do
    it 'transforms parameters in string to correct values' do
      expect(
        service.send
      ).to eq "#{receiver.name} #{sender.name} #{receiver.leader} #{sender.leader} #{receiver.title} #{sender.title}"
    end
  end
end
