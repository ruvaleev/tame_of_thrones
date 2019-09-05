class KingdomsController < ApplicationController
  def index
    @kingdoms = Kingdom.all
    @allies = Kingdom.find_by(name: 'Space').try(:vassals)
  end

  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
    render json: { head: :ok }
  end

  private

  def receiver
    Kingdom.find(params[:receiver_id])
  end
end
