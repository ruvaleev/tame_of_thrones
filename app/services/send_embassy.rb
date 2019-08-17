class SendEmbassy
  attr_reader :message, :sender, :receiver

  def initialize(message)
    @message  = message
    @receiver = message.receiver
    @sender   = message.sender
  end

  def ask_for_allegiance
    receiver.emblem.downcase.each_char do |l|
      return false if message.body.downcase.slice!(l).nil?
    end
    sender.vassals << receiver
  end
end
