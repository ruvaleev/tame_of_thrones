# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response do
  let(:sender) { create(:kingdom) }
  let(:receiver) { create(:kingdom) }
  let(:response) { 'consent' }

  subject(:service) { described_class.new(sender, receiver, response) }

  before do
    service.stub(:choose_response) { '%{receiver_name}% %{receiver_king}% %{sender_name}% %{sender_king}%'.dup }
  end

  describe '#send' do
    it 'transforms parameters in string to correct values' do
      expect(service.send).to eq "#{receiver.name_en} #{receiver.leader_en} #{sender.name_en} #{sender.leader_en}"
    end
  end
end
