# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  it { should validate_presence_of(:body) }
  it { should belong_to(:sender).class_name('Kingdom').with_foreign_key('sender_id').inverse_of(:sent_messages) }
  it do
    should belong_to(:receiver).class_name('Kingdom').with_foreign_key('receiver_id').inverse_of(:received_messages)
  end
end
