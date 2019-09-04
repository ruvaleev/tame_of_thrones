class KingdomsController < ApplicationController
  def index
    @kingdoms = Kingdom.all
  end

  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
  end

  private

  def receiver
    Kingdom.find(params[:receiver_id])
  end
end
