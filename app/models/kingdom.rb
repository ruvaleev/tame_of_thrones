# frozen_string_literal: true

class Kingdom < ApplicationRecord
  belongs_to :sovereign, class_name: 'Kingdom', optional: true
  has_many :vassals, class_name: 'Kingdom', foreign_key: 'sovereign_id', inverse_of: :sovereign, dependent: :nullify

  with_options class_name: 'Message' do
    has_many :sent_messages, foreign_key: 'sender_id', inverse_of: :sender, dependent: :destroy
    has_many :received_messages, foreign_key: 'receiver_id', inverse_of: :receiver, dependent: :nullify
  end

  def ask_for_allegiance(kingdom, text)
    message = prepare_message(kingdom, text)
    SendEmbassy.new(message).ask_for_allegiance
  end

  def prepare_message(receiver, text)
    sent_messages.create(receiver: receiver, body: text)
  end
end


__END__
arr_of_arrs = File.read("public/uploads/boc-messages.txt")

arr_of_arrs.split("\n")