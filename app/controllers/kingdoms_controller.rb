class KingdomsController < ApplicationController
  def reset_alliances
    Message.destroy_all
    Kingdom.all.update(sovereign_id: nil, ruler: false)
  end

  private

  def price_params
    params.require(:price).permit(:file)
  end
end
