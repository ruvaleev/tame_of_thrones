class KingdomsController < ApplicationController
  def index
    @kingdoms = Kingdom.all
  end

  def begin_dialogue(sender = nil)
    sender ||= Kingdom.find_by(name: 'Space')
    @message = sender.sent_messages.new(receiver: receiver)
  end

  # def golden_crown_game
  #   message = params[:message]
  #   kingdom = Kingdom.find(params[:id])
  #   space_kingdom = Kingdom.find_by(name: 'Space')
  # end

  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
  end

  private

  def receiver
    Kingdom.find(params[:receiver_id])
  end
end
