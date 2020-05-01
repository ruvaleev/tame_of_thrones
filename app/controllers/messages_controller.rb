# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :find_receiver
  before_action :find_sender

  def create
    response, message, new_king = @sender.ask_for_allegiance(@receiver, params[:body])
    render json: { message: message,
                   response: response,
                   receiver_id: @receiver.id,
                   new_king: new_king,
                   kings_name: @sender.leader.upcase,
                   kingdoms_name: @sender.name }
  end

  def greeting
    message = @receiver.greeting(@sender)
    render json: { message: message,
                   king: @receiver.leader,
                   name: @receiver.name }
  end

  private

  def find_sender
    @sender = @receiver.game_set.player
  end

  def find_receiver
    @receiver = Kingdom.find(params[:receiver_id])
  end
end
