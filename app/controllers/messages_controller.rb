# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :find_sender
  before_action :find_receiver

  def create
    response, message, new_king = @sender.ask_for_allegiance(@receiver, params[:body])
    render json: { message: message,
                   response: response,
                   receiver_id: @receiver.id,
                   new_king: new_king,
                   kings_name: @sender.king.upcase,
                   kingdoms_name: @sender.translated_name }
  end

  def greeting
    message = @receiver.greeting(@sender)
    render json: { message: message,
                   king: @receiver.king,
                   translated_name: @receiver.translated_name }
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
