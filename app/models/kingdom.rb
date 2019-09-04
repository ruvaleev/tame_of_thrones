# frozen_string_literal: true

class Kingdom < ApplicationRecord
  belongs_to :sovereign, class_name: 'Kingdom', optional: true
  has_many :vassals, class_name: 'Kingdom', foreign_key: 'sovereign_id', inverse_of: :sovereign, dependent: :nullify

  with_options class_name: 'Message' do
    has_many :sent_messages, foreign_key: 'sender_id', inverse_of: :sender, dependent: :destroy
    has_many :received_messages, foreign_key: 'receiver_id', inverse_of: :receiver, dependent: :nullify
  end

  validates :name, uniqueness: true
  validates :emblem, uniqueness: true
  validates :king, presence: true

  mount_uploader :emblem_avatar, AvatarUploader
  mount_uploader :king_avatar, AvatarUploader

  def ask_for_allegiance(kingdom, text)
    message = prepare_message(kingdom, text)
    agreed = SendEmbassy.new(message).ask_for_allegiance
    response = agreed ? 'consent' : 'refusal'
    Response.new(self, kingdom, response).send
  end

  def greeting(kingdom)
    response = "#{recognize_status(kingdom)}_greeting"
    Response.new(self, kingdom, response).send
  end

  private

  def prepare_message(receiver, text)
    sent_messages.create(receiver: receiver, body: text)
  end

  def recognize_status(kingdom)
    if sovereign_of?(kingdom) || vassal_of?(kingdom)
      'ally'
    elsif got_messages?(kingdom)
      'enemy'
    else
      'neutral'
    end
  end

  def sovereign_of?(kingdom)
    eql?(kingdom.sovereign)
  end

  def vassal_of?(kingdom)
    kingdom.vassals.include?(self)
  end

  def got_messages?(kingdom)
    sent_messages.pluck(:receiver_id).concat(received_messages.pluck(:sender_id)).include?(kingdom.id)
  end
end
