class KingdomsController < ApplicationController
  def index
    @kingdoms = Kingdom.all
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
end
