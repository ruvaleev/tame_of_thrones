class MessagesController < ApplicationController
  before_action :find_sender
  before_action :find_receiver

  def create
    response, message, new_king = @sender.ask_for_allegiance(@receiver, params[:body])
    render json: { message: message,
                   response: response,
                   receiver_id: @receiver.id,
                   new_king: new_king,
                   kings_name: @sender.king,
                   kingdoms_name: @sender.name }
  end

  def greeting
    message = @receiver.greeting(@sender)
    render json: { message: message }
  end

  private

  def find_sender
    sender_id = params[:sender_id] || Kingdom.find_by(name: 'Space').id
    @sender = Kingdom.find(sender_id)
  end

  def find_receiver
    @receiver = Kingdom.find(params[:receiver_id])
  end
end
